package main

import (
	"fmt"
	"log"
	"math"
	"os"

	tea "github.com/charmbracelet/bubbletea"
	"golang.org/x/term"
)

type model struct {
	currentValue int
	termHeight   int
}

func initializeModel() (model, error) {
	_, h, err := term.GetSize(int(os.Stdin.Fd()))
	if err != nil {
		return model{}, err
	}

	m := model{termHeight: h}

	return m, nil
}

func (m *model) calculateLevel(value int) {
	step := 100 / float64(m.termHeight)
	level := step * float64(value)
	m.currentValue = int(math.Ceil(level))
	if m.currentValue >= 97 {
		m.currentValue = 100
	}
	if m.currentValue < 4 {
		m.currentValue = 0
	}
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.MouseMsg:
		m.calculateLevel(msg.Y)
	}
	return m, nil
}

func (m model) View() string {
	return fmt.Sprintf("%d", m.currentValue)
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
