package main

import "github.com/charmbracelet/lipgloss"

// theme: kanagawa-dragon
const darkLight = "#282727"
const dark = "#181616"
const darker = "#1D1C19"
const light = "#c5c9c5"
const red = "#c4746e"

var header = lipgloss.NewStyle().
	Background(lipgloss.Color(darker)).
	Foreground(lipgloss.Color(light))

var prompt = lipgloss.NewStyle().
	Background(lipgloss.Color(darker)).
	Foreground(lipgloss.Color(light))

var headerTitle = lipgloss.NewStyle().
	Background(lipgloss.Color(red)).
	Foreground(lipgloss.Color(dark)).
	Bold(true)

var body = lipgloss.NewStyle().
	Background(lipgloss.Color(darkLight)).
	Foreground(lipgloss.Color(light))

var line = lipgloss.NewStyle().
	Background(lipgloss.Color(darkLight)).
	Foreground(lipgloss.Color(light))

var selectedLine = lipgloss.NewStyle().
	Background(lipgloss.Color(red)).
	Foreground(lipgloss.Color(dark))
