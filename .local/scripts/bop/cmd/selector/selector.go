package selector

import (
	"fmt"
	"log"
	"strings"

	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type model struct {
	termH int
	termW int
	input textinput.Model
	err   error
	songs songsModel
}

func newModel() model {
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

	songs := []song{
		{false, "Covet", "Basement", "4:31"},
		{true, "Ghost Town", "Kanye", "4:31"},
		{false, "Pink Matter", "Frank Ocean", "4:31"},
	}
	s := newSongsModel(songs)

	return model{
		termH: 40,
		termW: 80,
		input: ti,
		err:   nil,
		songs: s,
	}
}

func (m *model) resize(msg tea.WindowSizeMsg) {
	m.termH = msg.Height
	m.termW = msg.Width
	m.input.Width = m.termW - 4
	m.input.CharLimit = m.termW - 8
	m.songs.SetWidth(m.termW)
	m.songs.SetHeight(m.termH - 4)
  helpLInfo.Width(m.termW/2)
  helpRInfo.Width(m.termW/2)
  helpInfo.Width(m.termW)
}

func (m model) Init() tea.Cmd {
	return textinput.Blink
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.resize(msg)

	case tea.KeyMsg:
		switch msg.Type {
		case tea.KeyCtrlC, tea.KeyEscape:
			return m, tea.Quit

		case tea.KeyTab, tea.KeyShiftTab:
			if m.input.Focused() {
				m.input.Blur()
				m.songs.Focus()
			} else {
				m.input.Focus()
				m.songs.Blur()
			}
		}
	}

	var cmd tea.Cmd
	var cmds []tea.Cmd
	m.input, cmd = m.input.Update(msg)
	cmds = append(cmds, cmd)

	m.songs, cmd = m.songs.Update(msg)
	cmds = append(cmds, cmd)

	return m, tea.Batch(cmds...)
}

func (m model) View() string {
	s := strings.Builder{}

	// HEADER/PROMPT
	input := inputS.Render(m.input.View())
	prompt := promptS.Render("  ")
	s.WriteString(lipgloss.JoinHorizontal(lipgloss.Left, prompt, input))
	s.WriteString("\n")

	// SONGS LIST
	s.WriteString(m.songs.View())
	s.WriteString("\n")

	// HELP AND INFO
  songCount := m.songs.SongsLen()
  count := helpRInfo.Render(fmt.Sprintf("%d songs queued.", songCount))
  help := helpLInfo.Render("Press Esc to quit.")

	s.WriteString(helpInfo.Render(lipgloss.JoinHorizontal(lipgloss.Left, help, count)))

	content := lipgloss.Place(m.termW, m.termH, lipgloss.Center, lipgloss.Top, s.String())

	return content
}

func Run() {
	m := newModel()
	program := tea.NewProgram(m)
	if _, err := program.Run(); err != nil {
		log.Fatal(err)
	}
}
