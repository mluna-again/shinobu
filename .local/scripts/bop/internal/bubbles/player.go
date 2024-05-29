package bubbles

import (
	"bop/internal"
	"time"

	"github.com/charmbracelet/bubbles/progress"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type tickMsg time.Time

func doTick() tea.Cmd {
	return tea.Tick(time.Second*1, func(t time.Time) tea.Msg {
		return tickMsg{}
	})
}

type Player struct {
	CurrentSecond int
	TotalSeconds  int
	bar           progress.Model
}

func NewPlayer(current, total int) Player {
	color1 := string(internal.KanagawaDragon.Primary)
	color2 := string(internal.KanagawaDragon.Secondary)
	b := progress.New(progress.WithScaledGradient(color1, color2), progress.WithoutPercentage())

	return Player{
		CurrentSecond: current,
		TotalSeconds:  total,
		bar:           b,
	}
}

func (m Player) Init() tea.Cmd {
	return doTick()
}

func (m Player) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
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
		m.bar.Width = msg.Width - 14 // start-end time padding
		return m, nil

	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c":
			return m, tea.Quit
		}
	}

	return m, nil
}

func (m Player) View() string {
	bar := m.bar.ViewAs(m.calculateNextSecondTick())
	return lipgloss.JoinHorizontal(lipgloss.Left, timeStyle.Render("00:31"), bar, timeStyle.Render("01:34"))
}

func (m Player) calculateNextSecondTick() float64 {
	step := (100 / float64(m.TotalSeconds)) * float64(m.CurrentSecond)

	return step / 100
}
