package selector

import (
	"strings"

	"github.com/charmbracelet/bubbles/viewport"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type song struct {
	Selected bool
	Name     string
	Artist   string
	Duration string
}

type songsModel struct {
	songs    []song
	focused  bool
	viewport viewport.Model
	index    int
}

func newSongsModel(songs []song) songsModel {
	v := viewport.New(0, 0)

	return songsModel{
		songs:    songs,
		viewport: v,
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
		case "j":
			if m.index < len(m.songs)-1 {
				m.index++
			} else {
				m.index = 0
			}

		case "k":
			if m.index > 0 {
				m.index--
			} else {
				m.index = len(m.songs) - 1
			}

		case " ":
			for i := 0; i < len(m.songs); i++ {
				if i == m.index {
					m.songs[i].Selected = !m.songs[i].Selected
				}
			}
		}
	}

	content := m.makeSongs(m.songs)
	m.viewport.SetContent(content)

	var (
		cmd  tea.Cmd
		cmds []tea.Cmd
	)

	m.viewport, cmd = m.viewport.Update(msg)
	cmds = append(cmds, cmd)

	return m, tea.Batch(cmds...)
}

func (m songsModel) View() string {
	return songViewportS.Render(m.viewport.View())
}

func (m *songsModel) SetHeight(h int) {
	m.viewport.Height = h
}

func (m *songsModel) SetWidth(w int) {
	m.viewport.Width = w
	songCellS.Width(w / 4)
	songCellSelectedS.Width(w / 4)
	songColS.Width(w / 4)
	songHeaderS.Width(w)
	songItemS.Width(w)
	songItemSelectedS.Width(w)
}

func (m *songsModel) Focus() {
	m.focused = true
}

func (m *songsModel) Blur() {
	m.focused = true
}

func (m songsModel) Focused() bool {
	return m.focused
}

func (m songsModel) SongsLen() int {
	count := 0
	for _, s := range m.songs {
		if s.Selected {
			count++
		}
	}

	return count
}

func (m songsModel) makeSongs(ss []song) string {
	b := strings.Builder{}
	header := lipgloss.JoinHorizontal(lipgloss.Left, songColS.Render("Selected"), songColS.Render("Name"), songColS.Render("Artist"), songColS.Render("Duration"))
	b.WriteString(songHeaderS.Render(header))
	b.WriteString("\n")

	for i, s := range ss {
		var cs lipgloss.Style
		if i == m.index {
			cs = songCellSelectedS
		} else {
			cs = songCellS
		}

		selCol := ""
		if s.Selected {
			selCol = ""
		}
		msg := lipgloss.JoinHorizontal(lipgloss.Left, cs.Render(selCol), cs.Render(s.Name), cs.Render(s.Artist), cs.Render(s.Duration))

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
