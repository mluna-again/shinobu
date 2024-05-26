package queueview

import (
	"fmt"
	"io"

	"github.com/charmbracelet/bubbles/list"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type itemDelegate struct{}

func (d itemDelegate) Height() int  { return 6 }
func (d itemDelegate) Spacing() int { return 0 }
func (d itemDelegate) Update(_ tea.Msg, m *list.Model) tea.Cmd {
	itemStyle.Width(m.Width())
	selectedItemStyle.Width(m.Width())
	return nil
}
func (d itemDelegate) Render(w io.Writer, m list.Model, index int, listItem list.Item) {
	i, ok := listItem.(item)
	if !ok {
		return
	}

	icon := iconStyle.Render(i.Ascii)
	if i.Ascii == "" {
		icon = `//////
//////
//////
//////
//////`
	}
	details := lipgloss.JoinVertical(lipgloss.Left, i.Name, i.Artist, i.Duration)
	str := lipgloss.JoinHorizontal(lipgloss.Top, icon, " ", details)

	fn := itemStyle.Render
	if index == m.Index() {
		fn = selectedItemStyle.Render
	}

	fmt.Fprint(w, fn(str))
}
