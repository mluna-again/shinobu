package main

import (
	"github.com/charmbracelet/lipgloss"
)

var bg = lipgloss.Color("#181616")

var banner = lipgloss.NewStyle().
	Foreground(lipgloss.Color("#FAFAFA")).
	PaddingTop(2).
	PaddingBottom(2)

var quoteStyle = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center).
	Foreground(lipgloss.Color("#FAFAFA")).
	PaddingTop(1)

var title = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center).
	Foreground(lipgloss.Color("#FAFAFA")).
	PaddingBottom(1).
	PaddingTop(1)

var help = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center).
	Foreground(lipgloss.Color("#585959")).
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
