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
	index         int
	focused       bool
	theme         Theme
}

func newQueue(t Theme) queueModel {
	v := viewport.New(0, 0)
	v.Style = queueViewportS

	return queueModel{
		viewport:      v,
		theme:         t,
		originalSongs: map[string]Song{},
	}
}

func (m queueModel) Init() tea.Cmd {
	return nil
}

func (m queueModel) Update(msg tea.Msg) (queueModel, tea.Cmd) {
	_, iswinmsg := msg.(tea.WindowSizeMsg)
	if !m.focused && !iswinmsg {
		return m, nil
	}
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.resize(msg)

	case tea.KeyMsg:
		switch msg.String() {
		case "D":
			m.originalSongs = map[string]Song{}
			m.orderedSongs = []Song{}
			return m, nil

		case "d":
			if len(m.orderedSongs) == 0 {
				break
			}
			delete(m.originalSongs, m.orderedSongs[m.index].ID)
			m.orderedSongs = append(m.orderedSongs[0:m.index], m.orderedSongs[m.index+1:]...)
			if m.index > 0 {
				m.index--
			} else {
				m.index = 0
			}

		case "j":
			if m.index < len(m.orderedSongs)-1 {
				m.index++
				m.viewport.LineDown(3)
			} else {
				m.index = 0
				m.viewport.GotoTop()
			}

		case "k":
			if m.index > 0 {
				m.index--
				m.viewport.LineUp(3)
			} else {
				m.index = len(m.orderedSongs) - 1
				m.viewport.GotoBottom()
			}

		case "g":
			m.viewport.GotoTop()
			m.index = 0

		case "G":
			m.viewport.GotoBottom()
			m.index = len(m.orderedSongs) - 1

		case "J":
			if m.index < len(m.orderedSongs)-1 {
				m.resortSong(false)
				m.index++
				m.viewport.LineDown(3)
			}

		case "K":
			if m.index > 0 {
				m.resortSong(true)
				m.index--
				m.viewport.LineUp(3)
			}
		}
	}
	m.redrawViewport()

	return m, nil
}

func (m queueModel) View() string {
	h := queueHeaderComptS
	header := lipgloss.JoinHorizontal(lipgloss.Left, h.Render("Name"), h.Render("Artist"), h.Render("Duration"))
	header = lipgloss.PlaceHorizontal(m.termW, lipgloss.Left, header, lipgloss.WithWhitespaceBackground(m.theme.BGDark))

	help := lipgloss.PlaceHorizontal(m.termW, lipgloss.Left, "Use J/K to reorder songs. d to delete songs. Press Enter to exit or Esc to go back.")
	help = helpInfo.Render(help)
	return lipgloss.JoinVertical(lipgloss.Top, header, m.viewport.View(), help)
}

func (m *queueModel) SetSongs(s map[string]Song) {
	m.originalSongs = s
	m.orderedSongs = []Song{}
	for _, s := range m.originalSongs {
		m.orderedSongs = append(m.orderedSongs, s)
	}
	m.clearSongs()
	m.redrawViewport()
}

func (m *queueModel) AppendSongs(s map[string]Song) {
	songs := []Song{}
	for k, v := range s {
		m.originalSongs[k] = v
		songs = append(songs, v)
	}

	m.orderedSongs = append(m.orderedSongs, songs...)
	m.clearSongs()
	m.redrawViewport()
}

func (m queueModel) GetSongs() []Song {
	return m.orderedSongs
}

func (m *queueModel) Focus() {
	m.focused = true
}

func (m *queueModel) Blur() {
	m.focused = false
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
	queueSongComptSelectedS.Width(m.termW / 3)
	queueHeaderComptS.Width(m.termW / 3)
	m.viewport.Height = m.termH - 4
	m.viewport.Width = m.termW
	m.redrawViewport()
}

func (m *queueModel) redrawViewport() {
	songs := []string{}

	for i, song := range m.orderedSongs {
		s := queueSongComptS
		if i == m.index {
			s = queueSongComptSelectedS
		}
		row := lipgloss.JoinHorizontal(lipgloss.Left, s.Render(song.Name), s.Render(song.Artist), s.Render(song.Duration))
		row = lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, row, lipgloss.WithWhitespaceBackground(m.theme.BGDark))
		songs = append(songs, row)
	}

	content := lipgloss.JoinVertical(lipgloss.Top, songs...)
	m.viewport.SetContent(content)
}

// what the hell man
func (m *queueModel) resortSong(up bool) {
	songs := []Song{}

	var prev Song
	for i, s := range m.orderedSongs {
		if i == m.index+1 && !up {
			songs = append(songs, s)
			songs = append(songs, prev)
			continue
		}

		if i == m.index && !up {
			prev = s
			continue
		}

		if up && i == m.index-1 {
			prev = s
			continue
		}

		if up && i == m.index {
			songs = append(songs, s)
			songs = append(songs, prev)
			continue
		}

		if i != m.index {
			songs = append(songs, s)
			continue
		}

	}

	m.orderedSongs = songs
}
