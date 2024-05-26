package queueview

import (
	"github.com/charmbracelet/lipgloss"
)

var itemStyle = lipgloss.NewStyle()
var selectedItemStyle = lipgloss.NewStyle()

var iconStyle = lipgloss.NewStyle()
var iconSelectedStyle = lipgloss.NewStyle()

var paginationStyle = lipgloss.NewStyle().Padding(0).Margin(0).AlignHorizontal(lipgloss.Center).Height(1)

func (m model) loadTheme() {
	selectedItemStyle = selectedItemStyle.Background(m.theme.BGDark)
	iconSelectedStyle = iconSelectedStyle.Background(m.theme.BGDark)
}
