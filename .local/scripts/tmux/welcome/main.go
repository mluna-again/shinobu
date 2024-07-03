package main

import (
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/charmbracelet/bubbles/key"
	"github.com/charmbracelet/bubbles/list"
	"github.com/charmbracelet/bubbles/paginator"
	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var termHeight int
var termWidth int
var resultsFile string
var quote string
var animated bool

func loadsessions() ([]list.Item, error) {
	sessions, err := io.ReadAll(os.Stdin)
	if err != nil {
		return []list.Item{}, err
	}

	sess := strings.Split(string(sessions), "\n")
	items := []list.Item{}
	for _, s := range sess {
		cmps := strings.Split(s, " ")
		if len(cmps) < 3 {
			continue
		}

		wins, err := strconv.Atoi(cmps[1])
		if err != nil {
			return []list.Item{}, fmt.Errorf("Bad Session Date: %v", cmps[1])
		}

		sx := item{
			name:            cmps[0],
			index:           cmps[2],
			numberOfWindows: wins,
		}
		items = append(items, sx)
	}

	return items, nil
}

type model struct {
	sessions      list.Model
	termH         int
	termW         int
	selected      string
	banner        string
	bannerFrames  []string
	bannerFrame   int
	quote         string
	isSSH         bool
	rebooting     bool
	shutting      bool
	creatingNew   bool
	killingServer bool
	input         textinput.Model
}

func initialModel() (model, error) {
	sessions, err := loadsessions()
	if err != nil {
		return model{}, err
	}

	l := list.New(sessions, itemDelegate{}, termWidth, 20)
	l.SetShowStatusBar(false)
	l.SetFilteringEnabled(true)
	l.SetShowFilter(false)
	l.SetShowHelp(false)
	l.SetShowTitle(false)
	l.SetShowPagination(false)
	l.Styles.Title = titleStyle
	l.DisableQuitKeybindings()
	l.Paginator.KeyMap = paginator.KeyMap{}
	l.KeyMap = list.KeyMap{}
	l.KeyMap.GoToStart = key.NewBinding(key.WithKeys("g"))
	l.KeyMap.GoToEnd = key.NewBinding(key.WithKeys("G"))
	l.KeyMap.Filter = key.NewBinding(key.WithKeys("/", " "))
	l.InfiniteScrolling = true

	ssh := os.Getenv("SSH_CONNECTION")

	ti := textinput.New()
	ti.Placeholder = "Session name"
	ti.CharLimit = 30
	ti.Width = 35
	ti.Prompt = "  "

	banner := ""
	frames, err := ascii()
	if err != nil {
		return model{}, err
	}
	if len(frames) > 0 {
		banner = frames[0]
	}

	return model{
		sessions:     l,
		termH:        termHeight,
		termW:        termWidth,
		banner:       banner,
		bannerFrames: frames,
		bannerFrame:  0,
		quote:        quote,
		isSSH:        ssh != "",
		input:        ti,
	}, nil
}

func (m *model) resize() {
	m.resizeWithWidth(m.termW)
}

func (m *model) resizeWithHeight(h int) {
	m.termH = h
}

func (m *model) resizeWithWidth(w int) {
	m.termW = w
	banner.PaddingLeft((w / 2) - (lipgloss.Width(m.banner) / 2))
	pagination.Width(w)
	sessionItem.Width(w / 4)
	title.Width(w)
	help.Width(w)
	quoteStyle.Width(w)
}

func (m *model) shouldIgnoreInput() bool {
	return m.sessions.FilterState() == list.Filtering || m.creatingNew
}

func (m model) Init() tea.Cmd {
	var cmds []tea.Cmd
	cmds = append(cmds, textinput.Blink)
	if animated {
		cmds = append(cmds, bannerTick)
	}

	m.resize()
	return tea.Batch(cmds...)
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd

	switch msg := msg.(type) {
	case frameTickMsg:
		m.banner, m.bannerFrame = nextFrame(m.bannerFrames, m.bannerFrame)
		return m, tea.Tick(FRAME_TICK_DURATION, func(t time.Time) tea.Msg {
			return bannerTick()
		})

	case tea.WindowSizeMsg:
		m.sessions.SetHeight(msg.Height / 4)
		m.sessions.SetWidth(msg.Width)
		m.resizeWithWidth(msg.Width)
		m.resizeWithHeight(msg.Height)
		return m, nil

	case tea.KeyMsg:
		if m.shutting && msg.String() == "ctrl+q" {
			saveResults("@shutdown")
			return m, tea.Quit
		}

		if m.rebooting && msg.String() == "ctrl+r" {
			saveResults("@reboot")
			return m, tea.Quit
		}

		if m.killingServer && msg.String() == "Q" {
			saveResults("@kill-server")
			return m, tea.Quit
		}

		// its either rebooting or shutting down but no confirmation
		if m.rebooting || m.shutting || m.killingServer {
			m.rebooting = false
			m.shutting = false
			m.killingServer = false
		}

		switch msg.String() {
		case "d":
			if !m.shouldIgnoreInput() {
				saveResults("@detach")
				return m, tea.Quit
			}

		case "n":
			if !m.shouldIgnoreInput() {
				m.creatingNew = true
				m.input.Focus()
				return m, nil
			}

		case "Q":
			if !m.shouldIgnoreInput() {
				m.killingServer = true
				return m, nil
			}

		case "X":
			if !m.shouldIgnoreInput() {
				saveResults("@disconnect")
				return m, tea.Quit
			}

		case "ctrl+q":
			m.shutting = true
			return m, nil

		case "ctrl+r":
			m.rebooting = true
			return m, nil

		case "j", "down", "tab", "ctrl+n":
			if !m.shouldIgnoreInput() || msg.String() != "j" {
				m.sessions.CursorDown()
			}

		case "k", "up", "shift+tab", "ctrl+p":
			if !m.shouldIgnoreInput() || msg.String() != "k" {
				m.sessions.CursorUp()
			}

		case tea.KeyEscape.String():
			if m.shouldIgnoreInput() {
				m.sessions.FilterInput.Blur()
				m.sessions.ResetFilter()
				m.creatingNew = false
				m.input.Blur()
				return m, nil
			}

		case "ctrl+c":
			if !m.shouldIgnoreInput() {
				return m, tea.Quit
			}
			m.sessions.FilterInput.Blur()
			m.sessions.ResetFilter()
			return m, nil

		case "q":
			if !m.shouldIgnoreInput() {
				return m, tea.Quit
			}

		case "enter":
			if m.creatingNew {
				saveResults(fmt.Sprintf("@create %s", m.input.Value()))
				return m, tea.Quit
			}

			item, ok := m.sessions.SelectedItem().(item)
			if ok {
				m.selected = item.index
				saveResults(m.selected)
				return m, tea.Quit
			}
		}
	}

	var cmds []tea.Cmd
	if !m.creatingNew {
		m.sessions, cmd = m.sessions.Update(msg)
		cmds = append(cmds, cmd)
	}

	if m.creatingNew {
		m.input, cmd = m.input.Update(msg)
		cmds = append(cmds, cmd)
	}

	return m, tea.Batch(cmds...)
}

func (m model) View() string {
	s := strings.Builder{}

	header := banner.Render(m.banner)
	if m.termH > lipgloss.Height(header)+m.sessions.Height() {
		s.WriteString(header)
		s.WriteString("\n")
	} else {
		s.WriteString("\n\n")
	}

	s.WriteString(title.Render("Sessions"))
	s.WriteString("\n")

	sessions := lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, m.sessions.View())
	s.WriteString(sessions)
	s.WriteString("\n")

	count := fmt.Sprintf("%02d/%02d", m.sessions.Index()+1, len(m.sessions.VisibleItems()))
	s.WriteString("\n")
	s.WriteString(lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, count))
	s.WriteString("\n")
	s.WriteString("\n")

	if len(m.sessions.Items()) > m.sessions.Height() && !m.sessions.Paginator.OnLastPage() {
		s.WriteString(pagination.Render(""))
	}

	if m.sessions.FilterValue() != "" {
		s.WriteString(banner.Render(fmt.Sprintf(" %s", m.sessions.FilterValue())))
		s.WriteString("\n")
	}

	if m.creatingNew {
		s.WriteString("\n")
		content := lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, inputStyle.Render(m.input.View()))
		s.WriteString(content)
		s.WriteString("\n")
	}

	if m.sessions.FilterValue() == "" && !m.creatingNew {
		bar := "Exit (q)  Filter (/)  Detach (d)  New Session (n)"
		if m.isSSH {
			bar = fmt.Sprintf("%s  Disconnect (X)", bar)
		}
		bar = fmt.Sprintf("%s\nKill Server (Q)  Reboot (C-r)  Shut Down (C-q)", bar)

		if m.shutting {
			bar = "Are you sure? Type C-q again to confirm."
		}

		if m.rebooting {
			bar = "Are you sure? Type C-r again to confirm."
		}

		if m.killingServer {
			bar = "Are you sure? Type Q again to confirm."
		}

		s.WriteString(help.Render(bar))
		s.WriteString("\n")
	}

	s.WriteString(quoteStyle.Render(m.quote))
	s.WriteString("\n")

	dashboard := s.String()

	return lipgloss.Place(m.termW, m.termH, lipgloss.Center, lipgloss.Top, dashboard, lipgloss.WithWhitespaceBackground(bg))
}

func main() {
	flag.IntVar(&termWidth, "width", 80, "terminal width")
	flag.IntVar(&termHeight, "height", 40, "terminal height")
	flag.StringVar(&resultsFile, "result", "", "results file")
	flag.StringVar(&quote, "quote", "howdy", "quote")
	flag.BoolVar(&animated, "animate", false, "samurai animation")
	flag.Parse()

	m, err := initialModel()
	if err != nil {
		log.Fatal(err)
	}

	p := tea.NewProgram(m)
	if _, err := p.Run(); err != nil {
		fmt.Printf("Alas, there's been an error: %v", err)
		os.Exit(1)
	}
}

func saveResults(res string) {
	f, err := os.Create(resultsFile)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	_, err = f.WriteString(res)
	if err != nil {
		log.Fatal(err)
	}
}
