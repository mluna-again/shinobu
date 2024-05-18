package selector

import (
	"strings"

	"github.com/charmbracelet/bubbles/viewport"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type queueModel struct {
	originalSongs map[string]Song
	orderedSongs  []Song
	termW         int
	termH         int
	viewport      viewport.Model
}

func newQueue() queueModel {
	v := viewport.New(0, 0)
	v.Style = queueViewportS

	return queueModel{
		viewport: v,
	}
}

func (m queueModel) Init() tea.Cmd {
	return nil
}

func (m queueModel) Update(msg tea.Msg) (queueModel, tea.Cmd) {
	var cmd tea.Cmd
	var cmds []tea.Cmd

	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.resize(msg)

	case tea.KeyMsg:
		switch msg.String() {
		}
	}

	m.viewport, cmd = m.viewport.Update(msg)
	cmds = append(cmds, cmd)
	return m, tea.Batch(cmds...)
}

func (m queueModel) View() string {
	help := lipgloss.PlaceHorizontal(m.termW, lipgloss.Left, "Use J/K to reorder songs. Press Enter to exit or Esc to go back.")
	help = helpInfo.Render(help)
	return lipgloss.JoinVertical(lipgloss.Top, m.viewport.View(), help)
}

func (m *queueModel) SetSongs(s map[string]Song) {
	m.originalSongs = s
	for _, s := range m.originalSongs {
		m.orderedSongs = append(m.orderedSongs, s)
	}
	m.clearSongs()
	m.redrawViewport()
}

func (m queueModel) GetSongs() []Song {
	return m.orderedSongs
}

func (m *queueModel) clearSongs() {
	for i, s := range m.orderedSongs {
		m.orderedSongs[i].Name = strings.TrimPrefix(s.Name, "[SONG] ")
	}
}

func (m *queueModel) resize(msg tea.WindowSizeMsg) {
	m.termW = msg.Width
	m.termH = msg.Height

	queueSongComptS.Width(m.termW / 3)
	queueHeaderComptS.Width(m.termW / 3)
	m.viewport.Height = m.termH - 1
	m.viewport.Width = m.termW
	m.redrawViewport()
}

func (m *queueModel) redrawViewport() {
	s := queueSongComptS
	h := queueHeaderComptS

	songs := []string{}
	header := lipgloss.JoinHorizontal(lipgloss.Left, h.Render("Name"), h.Render("Artist"), h.Render("Duration"))
	songs = append(songs, header)

	for _, song := range m.orderedSongs {
		row := lipgloss.JoinHorizontal(lipgloss.Left, s.Render(song.Name), s.Render(song.Artist), s.Render(song.Duration))
		row = lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, row, lipgloss.WithWhitespaceBackground(darkerBlack))
		songs = append(songs, row)
	}

	content := lipgloss.JoinVertical(lipgloss.Top, songs...)
	m.viewport.SetContent(content)
}
