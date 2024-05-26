package queueview

import "github.com/charmbracelet/lipgloss"

var bg = lipgloss.Color("#000000")

var itemStyle = lipgloss.NewStyle()
var selectedItemStyle = lipgloss.NewStyle().Background(bg)

var iconStyle = lipgloss.NewStyle()

var paginationStyle = lipgloss.NewStyle().Padding(0).Margin(0).AlignHorizontal(lipgloss.Center).Height(1)
