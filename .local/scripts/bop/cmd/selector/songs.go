package selector

import (
	"fmt"
	"strings"
	"unicode/utf8"

	"github.com/charmbracelet/bubbles/viewport"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type Song struct {
	Selected bool   `json:"selected"`
	Name     string `json:"display_name"`
	Artist   string `json:"artist"`
	Duration string `json:"duration"`
	ID       string `json:"id"`
}

type songsModel struct {
	songs         []Song
	selectedSongs map[string]Song
	focused       bool
	viewport      viewport.Model
	index         int
}

func newSongsModel(songs []Song) songsModel {
	v := viewport.New(0, 0)

	return songsModel{
		songs:         songs,
		viewport:      v,
		selectedSongs: map[string]Song{},
	}
}

func (m songsModel) Init() tea.Cmd {
	return nil
}

func (m songsModel) Update(msg tea.Msg) (songsModel, tea.Cmd) {
	_, iswinmsg := msg.(tea.WindowSizeMsg)
	if !m.focused && !iswinmsg {
		return m, nil
	}

	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "g":
			m.viewport.GotoTop()
			m.index = 0

		case "G":
			m.viewport.GotoBottom()
			m.index = len(m.songs) - 1

		case "j":
			if m.index < len(m.songs)-1 {
				m.index++
				if m.index*3 >= m.viewport.VisibleLineCount()-3 {
					m.viewport.LineDown(3)
				}
			} else {
				m.index = 0
				m.viewport.GotoTop()
			}

		case "k":
			if m.index > 0 {
				m.index--
				m.viewport.LineUp(3)
			} else {
				m.index = len(m.songs) - 1
				m.viewport.GotoBottom()
			}

		case " ":
			for i := 0; i < len(m.songs); i++ {
				if i == m.index {
					m.songs[i].Selected = !m.songs[i].Selected
					if m.songs[i].Selected {
						m.addSelectedSong(m.songs[i])
					} else {
						m.removeSelectedSong(m.songs[i])
					}
				}
			}
		}
	}

	content := m.makeSongs(m.clearSongs(m.songs))
	m.viewport.SetContent(content)

	// var (
	// 	cmd  tea.Cmd
	// 	cmds []tea.Cmd
	// )
	//
	// m.viewport, cmd = m.viewport.Update(msg)
	// cmds = append(cmds, cmd)
	// return m, tea.Batch(cmds...)

	return m, nil
}

func (m songsModel) View() string {
	header := lipgloss.JoinHorizontal(lipgloss.Left, songSelColS.Render("Selected"), songColS.Render("Name"), songColS.Render("Artist"), songSelColS.Render("Duration"))

	return lipgloss.JoinVertical(lipgloss.Top, songViewportHeaderS.Render(header), songViewportS.Render(m.viewport.View()))
}

func (m *songsModel) SetHeight(h int) {
	m.viewport.Height = h - 3 // header
}

func (m *songsModel) SetWidth(w int) {
	m.viewport.Width = w
	songSelColS.Width(12)
	songSelColSelectedS.Width(12)
	songCellS.Width((w - 24) / 2)
	songCellSelectedS.Width((w - 24) / 2)
	songColS.Width((w - 24) / 2)
	songHeaderS.Width(w)
	songItemS.Width(w)
	songItemSelectedS.Width(w)
	songViewportS.Width(w)
	songViewportHeaderS.Width(w)
}

func (m *songsModel) Focus() {
	m.focused = true
}

func (m *songsModel) Blur() {
	m.focused = false
}

func (m songsModel) Focused() bool {
	return m.focused
}

func (m songsModel) SongsLen() int {
	return len(m.selectedSongs)
}

func (m *songsModel) SetSongs(songs []Song) {
	m.songs = songs
	content := m.makeSongs(m.clearSongs(m.songs))
	m.viewport.SetContent(content)
}

func (m songsModel) makeSongs(ss []Song) string {
	b := strings.Builder{}
	for i, s := range ss {
		var cs lipgloss.Style
		var selcs lipgloss.Style

		if i == m.index {
			cs = songCellSelectedS
			selcs = songSelColSelectedS
		} else {
			cs = songCellS
			selcs = songSelColS
		}

		selCol := ""
		if s.Selected {
			selCol = "  "
		}
		msg := lipgloss.JoinHorizontal(lipgloss.Left, selcs.Render(selCol), cs.Render(s.Name), cs.Render(s.Artist), selcs.Render(s.Duration))

		var style lipgloss.Style
		if i == m.index {
			style = songItemSelectedS
		} else {
			style = songItemS
		}
		b.WriteString(style.Render(msg))
		b.WriteString("\n")
	}

	return b.String()
}

func (m songsModel) clearSongs(songs []Song) []Song {
	clean := []Song{}

	for _, s := range songs {
		s.Name = strings.TrimPrefix(s.Name, "[SONG] ")
		if utf8.RuneCount([]byte(s.Name)) > m.viewport.Width/4 {
			s.Name = fmt.Sprintf("%s...", string([]rune(s.Name)[0:30]))
		}
		if utf8.RuneCount([]byte(s.Artist)) > m.viewport.Width/4 {
			s.Artist = fmt.Sprintf("%s...", string([]rune(s.Artist)[0:20]))
		}

		if _, ok := m.selectedSongs[s.ID]; ok {
			s.Selected = true
		}

		clean = append(clean, s)
	}

	return clean
}

func (m *songsModel) addSelectedSong(song Song) {
	m.selectedSongs[song.ID] = song
}

func (m *songsModel) removeSelectedSong(song Song) {
	delete(m.selectedSongs, song.ID)
}
