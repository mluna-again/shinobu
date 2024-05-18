package selector

import (
	"bop/internal"
	"fmt"
	"log"
	"os"
	"strings"

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
	termH         int
	termW         int
	input         textinput.Model
	err           error
	fetching      bool
	notFetchedYet bool
	songs         songsModel
	help          helpModel
	queue         queueModel
	screenIndex   screen
	devMode       bool
}

func newModel(c SelectorConfig) model {
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

	return model{
		termH:         40,
		termW:         80,
		input:         ti,
		err:           nil,
		notFetchedYet: true,
		songs:         s,
		help:          newHelp(),
		queue:         newQueue(),
		devMode:       c.DevMode,
		screenIndex:   songsScreen,
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

	m.help.termW = msg.Width
	m.help.termH = msg.Height
}

func (m model) Init() tea.Cmd {
	return textinput.Blink
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd
	var cmds []tea.Cmd

	switch msg := msg.(type) {
	case refetchedSongs:
		m.fetching = false
		if msg.err != nil {
			m.err = msg.err
		} else {
			m.songs.SetSongs(msg.songs)
			m.notFetchedYet = false
			m.err = nil
		}

	case addedToQueue:
		if msg.err != nil {
			m.err = msg.err
			return m, nil
		}
		for _, s := range m.songs.selectedSongs {
			fmt.Println(s.ID)
		}
		return m, tea.Quit

	case tea.WindowSizeMsg:
		m.resize(msg)

	case tea.KeyMsg:
		switch msg.String() {
		case "q":
			if m.input.Focused() {
				break
			}
			if m.screenIndex == queueScreen {
				m.screenIndex = songsScreen
				m.input.Focus()
				m.songs.Blur()
				m.queue.Blur()
				return m, nil
			} else {
				m.input.Blur()
				m.songs.Blur()
				m.queue.Focus()
				m.screenIndex = queueScreen
				m.queue.SetSongs(m.songs.selectedSongs)
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
			if m.input.Focused() {
				cmds = append(cmds, m.fetchSongs)
				return m, tea.Batch(cmds...)
			} else {
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

	return m, tea.Batch(cmds...)
}

func (m model) View() string {
	if m.screenIndex == helpScreen {
		return m.help.View()
	}

	if m.screenIndex == queueScreen {
		return m.queue.View()
	}

	s := strings.Builder{}

	// HEADER/PROMPT
	input := inputS.Render(m.input.View())
	prompt := promptS.Render("  ")
	prompt = lipgloss.JoinHorizontal(lipgloss.Left, prompt, input)
	s.WriteString(prompt)
	s.WriteString("\n")

	if m.err != nil {
		msg := fmt.Sprintf("Computer says: %s", m.err.Error())
		msg = lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, msg)
		msg = lipgloss.JoinVertical(lipgloss.Top, msg, internal.CenterBanner(m.termW, sadCat))
		msg = lipgloss.Place(m.termW, m.termH-lipgloss.Height(prompt), lipgloss.Center, lipgloss.Center, msg)
		s.WriteString(bannerBGS.Render(msg))
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
	count := helpRInfo.Render(fmt.Sprintf("%d songs queued.", songCount))
	help := helpLInfo.Render("Press ? for help.")

	s.WriteString(helpInfo.Render(lipgloss.JoinHorizontal(lipgloss.Left, help, count)))

	content := lipgloss.Place(m.termW, m.termH, lipgloss.Center, lipgloss.Top, s.String())

	return content
}

type SelectorConfig struct {
	DevMode bool
}

func Run(c SelectorConfig) {
	lipgloss.SetColorProfile(0)

	m := newModel(c)
	program := tea.NewProgram(m, tea.WithAltScreen(), tea.WithOutput(os.Stderr))
	finalModel, err := program.Run()
	if err != nil {
		log.Fatal(err)
	}

	finalM, ok := finalModel.(model)
	if !ok {
		panic("could not coerce model")
	}
	if finalM.err != nil {
		fmt.Println(finalM.err)
		os.Exit(1)
	}
}
