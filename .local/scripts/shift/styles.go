package main

import "github.com/charmbracelet/lipgloss"

// theme: kanagawa-dragon
const darkLight = "#282727"
const dark = "#181616"
const darker = "#1D1C19"
const light = "#c5c9c5"
const yellow = "#c4b28a"

var header = lipgloss.NewStyle().
	Background(lipgloss.Color(darker)).
	Foreground(lipgloss.Color(light)).
	Bold(false)

var prompt = lipgloss.NewStyle().
	Background(lipgloss.Color(darker)).
	Foreground(lipgloss.Color(light)).
	Bold(false)

var headerTitle = lipgloss.NewStyle().
	Background(lipgloss.Color(yellow)).
	Foreground(lipgloss.Color(dark)).
	Bold(false)

var line = lipgloss.NewStyle().
	Background(lipgloss.Color(darkLight)).
	Foreground(lipgloss.Color(light)).
	PaddingLeft(1).
	Bold(false)

var selectedLine = lipgloss.NewStyle().
	Background(lipgloss.Color(yellow)).
	Foreground(lipgloss.Color(dark)).
	Bold(false)
