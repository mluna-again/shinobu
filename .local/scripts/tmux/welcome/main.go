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

	"github.com/charmbracelet/bubbles/list"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var termHeight int
var termWidth int
var resultsFile string

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
		date, err := strconv.Atoi(cmps[1])
		if err != nil {
			return []list.Item{}, fmt.Errorf("Bad Session Date: %v", cmps[1])
		}
		lat := time.Unix(int64(date), 0)

		sx := item{
			name:           cmps[0],
			index:          cmps[2],
			lastAttachedAt: lat,
		}
		items = append(items, sx)
	}

	return items, nil
}

type model struct {
	sessions list.Model
	termH    int
	termW    int
	selected string
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

	return model{
		sessions: l,
		termH:    termHeight,
		termW:    termWidth,
	}, nil
}

func (m model) Init() tea.Cmd {
	banner.Width(m.termW)
	pagination.Width(m.termW)
	sessionItem.Width(m.termW / 4)

	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.sessions.SetWidth(msg.Width)
		return m, nil

	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit

		case "enter", " ":
			item, ok := m.sessions.SelectedItem().(item)
			if !ok {
				panic("Something went wrong while selecting item")
			}
			m.selected = item.index
			saveResults(m.selected)
			return m, tea.Quit
		}
	}

	var cmd tea.Cmd
	m.sessions, cmd = m.sessions.Update(msg)
	return m, cmd
}

func (m model) View() string {
	s := strings.Builder{}

	s.WriteString(banner.Render(ascii))
	s.WriteString("\n")

	sessions := lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, m.sessions.View())
	s.WriteString(sessions)
	s.WriteString("\n")
	if len(m.sessions.Items()) > m.sessions.Height() && !m.sessions.Paginator.OnLastPage() {
		s.WriteString(pagination.Render(""))
	}

	return s.String()
}

func main() {
	flag.IntVar(&termWidth, "width", 0, "terminal width")
	flag.IntVar(&termHeight, "height", 0, "terminal height")
	flag.StringVar(&resultsFile, "result", "", "results file")
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
