package main

import (
	"log"
	"math"
	"os"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"golang.org/x/term"
)

var backgroundStyle = lipgloss.
	NewStyle().
	Background(lipgloss.Color("235")).
	Foreground(lipgloss.Color("white"))

var barStyle = lipgloss.
	NewStyle().
	Background(lipgloss.Color("236")).
	Foreground(lipgloss.Color("yellow"))

const VOLUME_STEP = 4

type model struct {
	currentValue int
	termHeight   int
	termWidth    int
}

func initializeModel() (model, error) {
	w, h, err := term.GetSize(int(os.Stdin.Fd()))
	if err != nil {
		return model{}, err
	}

	m := model{termHeight: h, termWidth: w}

	return m, nil
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.MouseMsg:
		switch msg.Type {
		case tea.MouseWheelUp:
			if m.currentValue+VOLUME_STEP > 100 {
				m.currentValue = 100
				break
			}
			m.currentValue += VOLUME_STEP

		case tea.MouseWheelDown:
			if m.currentValue-VOLUME_STEP < 0 {
				m.currentValue = 0
				break
			}
			m.currentValue -= VOLUME_STEP

		case tea.MouseLeft:
			return m, tea.Quit
		case tea.MouseRight:
			return m, tea.Quit
		case tea.MouseMiddle:
			return m, tea.Quit
		}

	case tea.KeyMsg:
		if msg.String() == "ctrl+c" {
			return m, tea.Quit
		}
	}
	return m, nil
}

func (m model) View() string {
	b := strings.Builder{}
	w := m.termWidth
	if w < 1 {
		w = 1
	}
	padding := 6
	b.WriteString(backgroundStyle.Width(w).Render(""))
	b.WriteString("\n")
	b.WriteString(backgroundStyle.Width(padding / 2).Render("  "))

	step := float64(w-padding) / 100
	fullSteps := math.Ceil(step * float64(m.currentValue))

	for i := 0; i < int(fullSteps); i++ {
		b.WriteString(barStyle.Render("█"))
	}
	for i := 0; i < m.termWidth-int(fullSteps)-padding; i++ {
		b.WriteString(barStyle.Render(" "))
	}

	b.WriteString(backgroundStyle.Width(padding / 2).Render("  "))
	b.WriteString("\n")
	b.WriteString(backgroundStyle.Width(w).Render(""))

	return b.String()
}

func main() {
	m, err := initializeModel()
	if err != nil {
		log.Fatalln(err)
	}
	p := tea.NewProgram(m, tea.WithMouseAllMotion())
	if _, err := p.Run(); err != nil {
		log.Fatalln(err)
	}
}
