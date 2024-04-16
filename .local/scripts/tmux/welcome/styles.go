package main

import (
	"github.com/charmbracelet/lipgloss"
)

var banner = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center).
	Foreground(lipgloss.Color("#FAFAFA")).
	PaddingTop(2)

var sessionItem = lipgloss.NewStyle().
	Foreground(lipgloss.Color("#FAFAFA"))

var pagination = lipgloss.NewStyle().
	Foreground(lipgloss.Color("#FAFAFA")).
	AlignHorizontal(lipgloss.Center)

var (
	titleStyle        = lipgloss.NewStyle().MarginLeft(2)
	selectedItemStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("#c4b28a"))
)
