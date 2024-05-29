package bubbles

import (
	"bop/internal"
	"fmt"
	"time"

	"github.com/charmbracelet/bubbles/progress"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type tickMsg time.Time
type songFetchedMsg struct {
	song Song
	err  error
}

func (m Player) fetchSong() tea.Msg {
	width := m.termW
	if width <= 0 {
		width = 40
	}

	song, err := GetCurrentSong(width / 3)
	if err != nil {
		return songFetchedMsg{err: err}
	}

	return songFetchedMsg{song: song}
}

func doTick() tea.Cmd {
	return tea.Tick(time.Second*1, func(t time.Time) tea.Msg {
		return tickMsg{}
	})
}

type Player struct {
	CurrentSecond int
	TotalSeconds  int
	bar           progress.Model
	err           error
	termW         int
	termH         int
	cover         string
	loading       bool
}

func NewPlayer(current, total int) Player {
	color1 := string(internal.KanagawaDragon.Primary)
	color2 := string(internal.KanagawaDragon.Secondary)
	b := progress.New(progress.WithScaledGradient(color1, color2), progress.WithoutPercentage())

	return Player{
		CurrentSecond: current,
		TotalSeconds:  total,
		bar:           b,
		loading:       true,
	}
}

func (m Player) Init() tea.Cmd {
	return nil
}

func (m Player) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case songFetchedMsg:
		m.loading = false
		if msg.err != nil {
			m.err = msg.err
			return m, nil
		}
		m.CurrentSecond = msg.song.CurrentSecond
		m.TotalSeconds = msg.song.TotalSeconds
		m.cover = msg.song.Ascii
		return m, doTick()

	case tickMsg:
		if m.CurrentSecond >= m.TotalSeconds {
			break
		}
		m.CurrentSecond++
		return m, tea.Batch(doTick())

	case progress.FrameMsg:
		progressModel, cmd := m.bar.Update(msg)
		m.bar = progressModel.(progress.Model)
		return m, cmd

	case tea.WindowSizeMsg:
		m.termW = msg.Width
		m.termH = msg.Height
		m.bar.Width = msg.Width - 12 - ((msg.Width / 3) * 2) // start+end time and cover size
		return m, m.fetchSong

	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c":
			return m, tea.Quit
		}
	}

	return m, nil
}

func (m Player) View() string {
	if m.loading {
		return "Loading..."
	}

	if m.err != nil {
		return m.err.Error()
	}

	banner := lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, m.cover)
	bar := m.bar.ViewAs(m.calculateNextSecondTick())
	details := lipgloss.JoinHorizontal(lipgloss.Left, timeStyle.Render(toDuration(m.CurrentSecond)), bar, timeStyle.Render(toDuration(m.TotalSeconds-m.CurrentSecond)))

	return lipgloss.Place(m.termW-10, m.termH, lipgloss.Center, lipgloss.Center, lipgloss.JoinVertical(lipgloss.Center, banner, details))
}

func (m Player) calculateNextSecondTick() float64 {
	step := (100 / float64(m.TotalSeconds)) * float64(m.CurrentSecond)

	return step / 100
}

func toDuration(seconds int) string {
	minutes := seconds / 60
	seconds = seconds - (minutes * 60)
	return fmt.Sprintf("%02d:%02d", minutes, seconds)
}
