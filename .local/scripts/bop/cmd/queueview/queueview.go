package queueview

import (
	"bop/internal"
	"fmt"
	"os"

	"github.com/charmbracelet/bubbles/list"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type item struct {
	ID       string
	Name     string
	Artist   string
	Duration string
	Ascii    string
	URL      string
}

func (i item) Title() string       { return i.Name }
func (i item) Description() string { return i.Artist }
func (i item) FilterValue() string { return i.Name }

type model struct {
	list    list.Model
	err     error
	loading bool
	termH   int
	termW   int
	theme   internal.Theme
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd
	var cmds []tea.Cmd

	switch msg := msg.(type) {
	case queueLoadedMsg:
		if msg.err == nil {
			items := []list.Item{}
			for _, s := range msg.queue {
				items = append(items, s)
			}
			cmd := m.list.SetItems(items)
			cmds = append(cmds, cmd)
			return m, tea.Batch(cmds...)
		} else {
			m.err = msg.err
		}

	case newThumbnailMsg:
		index := -1
		var song item
		for i, v := range m.list.Items() {
			if item, ok := v.(item); ok && item.ID == msg.ID {
				index = i
				song = item
				song.Ascii = msg.ascii
			}
		}
		if index == -1 {
			break
		}
		m.list.SetItem(index, song)
		m.loading = false

	case thumbnailsLoadedMsg:
		m.loading = false

	case tea.KeyMsg:
		if msg.String() == "ctrl+c" {
			return m, tea.Quit
		}
	case tea.WindowSizeMsg:
		paginationStyle = paginationStyle.Width(msg.Width)
		m.list.Styles.PaginationStyle = paginationStyle
		m.list.SetSize(msg.Width, msg.Height)
		m.termW = msg.Width
		m.termH = msg.Height
	}

	m.list, cmd = m.list.Update(msg)
	cmds = append(cmds, cmd)
	return m, tea.Batch(cmds...)
}

func (m model) View() string {
	if m.err != nil {
		return lipgloss.Place(m.termW, m.termH, lipgloss.Center, lipgloss.Center, catSaysSerious(m.err.Error()))
	}

	if m.loading {
		return lipgloss.Place(m.termW, m.termH, lipgloss.Center, lipgloss.Center, catSays("Loading..."))
	}

	if len(m.list.Items()) == 0 {
		return lipgloss.Place(m.termW, m.termH, lipgloss.Center, lipgloss.Center, catSaysSerious("Queue empty"))
	}

	return m.list.View()
}

func Run() {
	items := []list.Item{}

	m := model{list: list.New(items, itemDelegate{}, 0, 0), loading: true, theme: internal.KanagawaDragon}
	m.list.SetShowTitle(false)
	m.list.SetShowHelp(false)
	m.list.SetShowFilter(false)
	m.list.SetShowPagination(true)
	m.list.SetShowStatusBar(false)
	m.list.Styles.PaginationStyle = paginationStyle
	m.loadTheme()

	p := tea.NewProgram(m, tea.WithAltScreen())

	go func() {
		if _, err := p.Run(); err != nil {
			fmt.Println("Error running program:", err)
			os.Exit(1)
		}
		os.Exit(0)
	}()

	go m.loadThumbnails(p)
	p.Wait()
}
