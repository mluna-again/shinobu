package selector

import (
	"bop/internal"
	"fmt"
	"os"
	"strings"

	"github.com/charmbracelet/bubbles/spinner"
	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type screen int

const (
	songsScreen screen = 1
	queueScreen screen = 2
	helpScreen  screen = 3
)

type model struct {
	termH             int
	termW             int
	input             textinput.Model
	spinner           spinner.Model
	err               error
	fetching          bool
	notFetchedYet     bool
	songs             songsModel
	help              helpModel
	queue             queueModel
	screenIndex       screen
	devMode           bool
	theme             Theme
	songsAddedToQueue bool
	exiting           bool
	currentPage       int
}

func newModel(c SelectorConfig) model {
	t := kanagawaDragon
	// TODO: more themes
	if c.Theme != "kanagawa-dragon" && c.Theme != "" {
		fmt.Fprintf(os.Stderr, "%s\n", "theme not implemented\n")
		os.Exit(2)
	}
	loadTheme(t)

	ti := textinput.New()
	ti.Placeholder = "Search songs..."
	ti.Focus()
	ti.CharLimit = 156
	ti.Width = 20
	ti.Prompt = ""
	ti.TextStyle = textS
	ti.PlaceholderStyle = placeholderS
	ti.Cursor.Style = cursorS
	ti.Cursor.TextStyle = cursorS

	songs := []Song{}
	s := newSongsModel(songs)

	sp := spinner.New()
	sp.Spinner = spinner.Dot

	return model{
		termH:         40,
		termW:         80,
		input:         ti,
		err:           nil,
		notFetchedYet: true,
		songs:         s,
		help:          newHelp(),
		queue:         newQueue(t),
		devMode:       c.DevMode,
		screenIndex:   songsScreen,
		theme:         t,
		spinner:       sp,
	}
}

func (m *model) resize(msg tea.WindowSizeMsg) {
	m.termH = msg.Height
	m.termW = msg.Width
	m.input.Width = m.termW - 4
	m.input.CharLimit = m.termW - 8
	m.songs.SetWidth(m.termW)
	m.songs.SetHeight(m.termH - 4)
	helpLInfo.Width(m.termW / 2)
	helpRInfo.Width(m.termW / 2)
	helpInfo.Width(m.termW)

	bannerLPadd := (m.termW / 2) - (lipgloss.Width(noSongsBanner) / 2)
	bannerS.PaddingLeft(bannerLPadd)
	bannerS.PaddingRight(m.termW - bannerLPadd)
	bannerS.Height(m.termH - 3)
	bannerWithHelpS.Height(m.termH - 4)
	bannerWithHelpS.PaddingLeft(bannerLPadd)
	bannerWithHelpS.PaddingRight(m.termW - bannerLPadd)

	m.help.termW = msg.Width
	m.help.termH = msg.Height
}

func (m model) Init() tea.Cmd {
	var cmds []tea.Cmd
	// cmds = append(cmds, textinput.Blink, m.checkServerStatus, m.getCurrentQueue)
	cmds = append(cmds, textinput.Blink, m.checkServerStatus)
	cmds = append(cmds, m.spinner.Tick)
	return tea.Batch(cmds...)
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd
	var cmds []tea.Cmd

	switch msg := msg.(type) {
	// it feels weird
	// case currentQueueMsg:
	// 	if msg.err != nil {
	// 		m.err = msg.err
	// 		return m, nil
	// 	}
	// 	m.queue.SetSongs(msg.mappedQueue)

	case serverStatusMsg:
		if msg.err != nil {
			m.err = msg.err
			return m, nil
		}

	case refetchedSongs:
		m.fetching = false
		if msg.err != nil {
			m.err = msg.err
		} else {
			m.songs.SetSongs(msg.songs)
			m.notFetchedYet = false
			m.err = nil
		}
		if len(msg.songs) > 0 {
			m.input.Blur()
			m.songs.Focus()
		}

	case addedToQueue:
		m.exiting = false
		if msg.err != nil {
			m.err = msg.err
			return m, nil
		}
		for _, s := range m.songs.selectedSongs {
			fmt.Println(s.ID)
		}
		m.songsAddedToQueue = !msg.empty
		return m, tea.Quit

	case tea.WindowSizeMsg:
		m.resize(msg)

	case tea.KeyMsg:
		switch msg.String() {
		case "l":
			if m.input.Focused() {
				break
			}
			if len(m.songs.songs) == 0 {
				return m, nil
			}
			m.fetching = true
			m.currentPage++
			return m, m.fetchSongs

		case "h":
			if m.input.Focused() {
				break
			}
			if m.currentPage <= 0 {
				return m, nil
			}
			m.fetching = true
			m.currentPage--
			return m, m.fetchSongs

		case "q":
			if m.input.Focused() {
				break
			}
			if m.screenIndex == queueScreen {
				m.screenIndex = songsScreen
				m.songs.ClearSelectedSongs()
				m.input.Focus()
				m.songs.Blur()
				m.queue.Blur()
				return m, nil
			} else {
				m.input.Blur()
				m.songs.Blur()
				m.queue.Focus()
				m.screenIndex = queueScreen
				m.queue.AppendSongs(m.songs.selectedSongs)
				return m, nil
			}

		case "?":
			if m.input.Focused() {
				break
			}

			if m.screenIndex == helpScreen {
				m.screenIndex = songsScreen
				m.input.Focus()
				m.songs.Blur()
				m.queue.Blur()
				return m, nil
			} else {
				m.screenIndex = helpScreen
				m.input.Blur()
				m.songs.Blur()
				m.queue.Blur()
				return m, nil
			}
		}

		switch msg.Type {
		case tea.KeyCtrlC, tea.KeyEscape:
			if m.err != nil {
				m.err = nil
				return m, nil
			}

			if m.screenIndex == helpScreen {
				m.songs.Blur()
				m.input.Focus()
				m.screenIndex = songsScreen
				return m, nil
			}

			if m.screenIndex == queueScreen {
				m.songs.Blur()
				m.input.Focus()
				m.screenIndex = songsScreen
				return m, nil
			}
			return m, tea.Quit

		case tea.KeyEnter:
			if m.exiting || m.fetching {
				break
			}

			if m.screenIndex == queueScreen {
				m.fetching = true
				return m, m.addToQueue
			}

			if m.input.Focused() {
				m.fetching = true
				cmds = append(cmds, m.fetchSongs)
				return m, tea.Batch(cmds...)
			}

			if m.screenIndex == songsScreen && !m.input.Focused() && m.noSongs() {
				m.exiting = true
				return m, m.addSelectedSongToQueue
			}

			if m.screenIndex == songsScreen {
				m.exiting = true
				return m, m.addToQueue
			}

		case tea.KeyTab, tea.KeyShiftTab:
			if m.notFetchedYet {
				return m, nil
			}

			if m.screenIndex != songsScreen {
				break
			}

			if m.input.Focused() {
				m.input.Blur()
				m.songs.Focus()
			} else {
				m.input.Focus()
				m.songs.Blur()
			}
		}
	}

	m.input, cmd = m.input.Update(msg)
	cmds = append(cmds, cmd)

	m.songs, cmd = m.songs.Update(msg)
	cmds = append(cmds, cmd)

	m.queue, cmd = m.queue.Update(msg)
	cmds = append(cmds, cmd)

	m.spinner, cmd = m.spinner.Update(msg)
	cmds = append(cmds, cmd)

	return m, tea.Batch(cmds...)
}

func (m model) noSongs() bool {
	return m.songs.SongsLen() == 0 && len(m.queue.GetSongs()) == 0
}

func (m model) View() string {
	s := strings.Builder{}
	if m.err != nil {
		msg := fmt.Sprintf("Computer says: %s", m.err.Error())
		msg = lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, msg)
		msg = lipgloss.JoinVertical(lipgloss.Top, msg, internal.CenterBanner(m.termW, sadCat))
		msg = lipgloss.Place(m.termW, m.termH, lipgloss.Center, lipgloss.Center, msg)
		s.WriteString(bannerBGS.Render(msg))
		return s.String()
	}

	if m.screenIndex == helpScreen {
		return m.help.View()
	}

	if m.screenIndex == queueScreen {
		return m.queue.View()
	}

	// HEADER/PROMPT
	input := inputS.Render(m.input.View())
	prompt := promptS.Render("  ")
	prompt = lipgloss.JoinHorizontal(lipgloss.Left, prompt, input)
	s.WriteString(prompt)
	s.WriteString("\n")

	if m.notFetchedYet && m.fetching {
		s.WriteString(bannerWithHelpS.Render(noSongsWithHelpBanner))
		s.WriteString("\n")
		s.WriteString(helpInfo.Render(lipgloss.PlaceHorizontal(m.termW, lipgloss.Right, m.spinner.View())))
		return s.String()
	}

	if m.notFetchedYet {
		s.WriteString(bannerS.Render(noSongsBanner))
		return s.String()
	}

	if !m.notFetchedYet && len(m.songs.songs) == 0 {
		s.WriteString(bannerS.Render(noResultsBanner))
		return s.String()
	}

	// SONGS LIST
	s.WriteString(m.songs.View())
	s.WriteString("\n")

	// HELP AND INFO
	songCount := m.songs.SongsLen()
	count := helpRInfo.Render(fmt.Sprintf("%d songs selected, %d songs queued.", songCount, len(m.queue.orderedSongs)))
	if m.fetching {
		count = helpRInfo.Render(m.spinner.View())
	}

	help := helpLInfo.Render("Press ? for help.")

	s.WriteString(helpInfo.Render(lipgloss.JoinHorizontal(lipgloss.Left, help, count)))

	content := lipgloss.Place(m.termW, m.termH, lipgloss.Center, lipgloss.Top, s.String())

	return content
}

type SelectorConfig struct {
	Theme   string
	DevMode bool
}

func Run(c SelectorConfig) {
	lipgloss.SetColorProfile(0)

	m := newModel(c)
	program := tea.NewProgram(m, tea.WithAltScreen(), tea.WithOutput(os.Stderr))
	finalModel, err := program.Run()
	if err != nil {
		fmt.Fprintln(os.Stderr, err.Error())
		os.Exit(2)
	}

	finalM, ok := finalModel.(model)
	if !ok {
		panic("could not coerce model")
	}
	if finalM.err != nil {
		fmt.Fprintln(os.Stderr, finalM.err.Error())
		os.Exit(2)
	}

	if finalM.songsAddedToQueue {
		os.Exit(0)
		return
	}

	os.Exit(1)
}
