package selector

import tea "github.com/charmbracelet/bubbletea"

type helpModel struct{}

func newHelp() helpModel {
	return helpModel{}
}

func (m helpModel) Init() tea.Cmd {
	return nil
}

func (m helpModel) Update(msg tea.Msg) (helpModel, tea.Cmd) {
	return m, nil
}

func (m helpModel) View() string {
	return ""
}
