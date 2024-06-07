package queueview

import (
	"bop/internal"
	"fmt"
	"os"
	"time"

	"github.com/charmbracelet/bubbles/list"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	zone "github.com/lrstanley/bubblezone"
)

type item struct {
	ID            string
	Name          string
	Artist        string
	Duration      string
	Ascii         string
	URL           string
	IsPlaying     bool
	CurrentSecond int
	TotalSeconds  int
	Liked         bool
}

func (i item) Title() string       { return i.Name }
func (i item) Description() string { return i.Artist }
func (i item) FilterValue() string { return i.Name }

type model struct {
	list        list.Model
	err         error
	loading     bool
	termH       int
	termW       int
	theme       internal.Theme
	reloadChan  chan struct{}
	likingSong  bool
	currentTick string
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd
	var cmds []tea.Cmd

	switch msg := msg.(type) {
	case songLikedOrDislikedMsg:
		m.likingSong = false
		if msg.err != nil {
			m.err = msg.err
			return m, nil
		}

		var updatedSong *item
		index := -1
		songs := m.list.Items()
		for i, s := range songs {
			song, ok := s.(item)
			if !ok {
				continue
			}

			if song.ID != msg.songID {
				continue
			}

			index = i
			updatedSong = &song
			break
		}
		if index != -1 {
			updatedSong.Liked = msg.liked
			m.list.SetItem(index, *updatedSong)
		}

	case queueLoadedMsg:
		if msg.err == nil {
			m.err = nil
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
		// schedule refresh at the end of the current song
		songs := m.list.Items()
		var current *item
		if len(songs) > 0 {
			s, ok := songs[0].(item)
			if ok {
				current = &s
			}
		}
		if current != nil && current.IsPlaying {
			remaining := current.TotalSeconds - current.CurrentSecond
			m.currentTick = time.Now().String()
			cmds = append(cmds, tea.Tick(time.Second*time.Duration(remaining), func(t time.Time) tea.Msg {
				return reloadQueueMsg{
					timestamp: m.currentTick,
				}
			}))
		}

		m.loading = false
		var someCover *string
		for _, s := range m.list.Items() {
			song, ok := s.(item)
			if !ok {
				continue
			}

			if song.Ascii != "" {
				someCover = &song.Ascii
			}
		}
		if someCover == nil {
			return m, tea.Batch(cmds...)
		}
		// i have no idea why i need to subtract 1 but if i don't it looks weird in *some*
		// screen sizes :/ and somehow subtracting 1 makes it look good in all sizes...
		delegate := itemDelegate{height: lipgloss.Height(*someCover) - 1}
		m.list.SetDelegate(delegate)

	case reloadQueueMsg:
		if msg.timestamp != m.currentTick {
			return m, nil
		}
		m.reloadChan <- struct{}{}
		m.loading = true
		m.err = nil
		return m, nil

	case tea.MouseMsg:
		if msg.Button == tea.MouseButtonWheelUp {
			index := m.list.Index()
			if index <= 0 {
				break
			}
			m.list.Select(index - 1)
		}

		if msg.Button == tea.MouseButtonWheelDown {
			index := m.list.Index()
			if index+1 >= len(m.list.Items()) {
				break
			}
			m.list.Select(index + 1)
		}

		if msg.Button == tea.MouseButtonLeft && msg.Action == tea.MouseActionRelease {
			for i, s := range m.list.Items() {
				song, ok := s.(item)
				if !ok {
					continue
				}
				if !zone.Get(song.ID).InBounds(msg) {
					continue
				}

				cmd := m.checkIfLikedClicked(song, msg)
				cmds = append(cmds, cmd)
				m.list.Select(i)
				break
			}
		}

	case tea.KeyMsg:
		if msg.String() == "ctrl+c" {
			return m, tea.Quit
		}

		switch msg.String() {
		case "r":
			m.reloadChan <- struct{}{}
			m.loading = true
			m.err = nil
			return m, nil
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
		return lipgloss.Place(m.termW, m.termH, lipgloss.Center, lipgloss.Center, internal.CatSaysSerious(m.err.Error()))
	}

	if m.loading {
		return lipgloss.Place(m.termW, m.termH, lipgloss.Center, lipgloss.Center, internal.CatSays("Loading..."))
	}

	if len(m.list.Items()) == 0 {
		return lipgloss.Place(m.termW, m.termH, lipgloss.Center, lipgloss.Center, internal.CatSaysSerious("Queue empty"))
	}

	return zone.Scan(m.list.View())
}

func (m *model) checkIfLikedClicked(song item, msg tea.MouseMsg) tea.Cmd {
	if m.likingSong {
		return nil
	}

	if !zone.Get(fmt.Sprintf("%s-liked", song.ID)).InBounds(msg) {
		return nil
	}

	m.likingSong = true

	return m.toggleSongLike(song)
}

func Run() {
	zone.NewGlobal()

	items := []list.Item{}
	reloadChan := make(chan struct{})

	m := model{list: list.New(items, itemDelegate{5}, 0, 0), loading: true, theme: internal.KanagawaDragon, reloadChan: reloadChan}
	m.list.SetShowTitle(false)
	m.list.SetShowHelp(false)
	m.list.SetShowFilter(false)
	m.list.SetShowPagination(true)
	m.list.SetShowStatusBar(false)
	m.list.InfiniteScrolling = true
	m.list.Styles.PaginationStyle = paginationStyle
	m.loadTheme()

	p := tea.NewProgram(m, tea.WithAltScreen(), tea.WithMouseCellMotion())

	go func() {
		if _, err := p.Run(); err != nil {
			fmt.Println("Error running program:", err)
			os.Exit(1)
		}
		os.Exit(0)
	}()

	go m.loadThumbnails(p)

	go func() {
		for {
			<-reloadChan
			go m.loadThumbnails(p)
		}
	}()

	p.Wait()
}
