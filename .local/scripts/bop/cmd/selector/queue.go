package selector

import tea "github.com/charmbracelet/bubbletea"

type queueModel struct{}

func newQueue() queueModel {
	return queueModel{}
}

func (m queueModel) Init() tea.Cmd {
	return nil
}

func (m queueModel) Update(msg tea.Msg) (queueModel, tea.Cmd) {
	return m, nil
}

func (m queueModel) View() string {
	return "WIP"
}
