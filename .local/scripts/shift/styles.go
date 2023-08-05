package main

import "github.com/charmbracelet/lipgloss"

// theme: kanagawa-dragon

type Colors struct {
	darkLight string
	dark      string
	darker    string
	light     string
	yellow    string
}

type Styles struct {
	header       lipgloss.Style
	prompt       lipgloss.Style
	headerTitle  lipgloss.Style
	line         lipgloss.Style
	selectedLine lipgloss.Style
}

var kanagawaDragon = Colors{
	darkLight: "#282727",
	dark:      "#181616",
	darker:    "#1D1C19",
	light:     "#c5c9c5",
	yellow:    "#c4b28a",
}

var kanagawaDragonStyles = Styles{
	header:      lipgloss.NewStyle().Background(lipgloss.Color(kanagawaDragon.darker)).Foreground(lipgloss.Color(kanagawaDragon.light)).Bold(false),
	prompt:      lipgloss.NewStyle().Background(lipgloss.Color(kanagawaDragon.darker)).Foreground(lipgloss.Color(kanagawaDragon.light)).Bold(false),
	headerTitle: lipgloss.NewStyle().Background(lipgloss.Color(kanagawaDragon.yellow)).Foreground(lipgloss.Color(kanagawaDragon.dark)).Bold(false),
	line: lipgloss.NewStyle().
		Background(lipgloss.Color(kanagawaDragon.darkLight)).
		Foreground(lipgloss.Color(kanagawaDragon.light)).
		PaddingLeft(1).
		Bold(false),
	selectedLine: lipgloss.NewStyle().
		Background(lipgloss.Color(kanagawaDragon.yellow)).
		Foreground(lipgloss.Color(kanagawaDragon.dark)).
		Bold(false),
}

func (app *app) loadTheme() {
	switch app.themeName {
	case "kanagawa-dragon":
		app.theme = kanagawaDragonStyles

	default:
		app.theme = kanagawaDragonStyles
	}
}
