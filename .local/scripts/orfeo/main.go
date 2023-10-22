package main

import (
	"log"
	"math"
	"os"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"golang.org/x/term"
)

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
	step := float64(w) / 100
	fullSteps := math.Ceil(step * float64(m.currentValue))

	for i := 0; i < int(fullSteps); i++ {
		b.WriteRune('█')
	}
	for i := 0; i < m.termWidth-int(fullSteps); i++ {
		b.WriteRune(' ')
	}

	b.WriteRune('\n')

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
