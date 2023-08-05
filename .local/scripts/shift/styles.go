package main

import (
	"os"
	"path"
	"strings"

	"github.com/charmbracelet/lipgloss"
)

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

var kanagawaWave = Colors{
	darkLight: "#252535",
	dark:      "#1F1F28",
	darker:    "#16161D",
	light:     "#DCD7BA",
	yellow:    "#E6C384",
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

var kanagawaWaveStyles = Styles{
	header:      lipgloss.NewStyle().Background(lipgloss.Color(kanagawaWave.darker)).Foreground(lipgloss.Color(kanagawaWave.light)).Bold(false),
	prompt:      lipgloss.NewStyle().Background(lipgloss.Color(kanagawaWave.darker)).Foreground(lipgloss.Color(kanagawaWave.light)).Bold(false),
	headerTitle: lipgloss.NewStyle().Background(lipgloss.Color(kanagawaWave.yellow)).Foreground(lipgloss.Color(kanagawaWave.dark)).Bold(false),
	line: lipgloss.NewStyle().
		Background(lipgloss.Color(kanagawaWave.darkLight)).
		Foreground(lipgloss.Color(kanagawaWave.light)).
		PaddingLeft(1).
		Bold(false),
	selectedLine: lipgloss.NewStyle().
		Background(lipgloss.Color(kanagawaWave.yellow)).
		Foreground(lipgloss.Color(kanagawaWave.dark)).
		Bold(false),
}

func getConfigThemeOrDefault() string {
	home, err := os.UserHomeDir()
	if err != nil {
		return "kanagawa-dragon"
	}
	themePath := path.Join(home, ".config/shift/theme")
	value, err := os.ReadFile(themePath)
	if err != nil {
		return "kanagawa-dragon"
	}
	return strings.TrimSpace(string(value))
}

func (app *app) loadTheme(theme string) {
	themeName := theme
	// theme flag was not set
	if theme == "" {
		themeName = getConfigThemeOrDefault()
	}

	switch themeName {
	case "kanagawa-dragon":
		app.theme = kanagawaDragonStyles

	case "kanagawa-wave":
		app.theme = kanagawaWaveStyles

	default:
		app.theme = kanagawaDragonStyles
	}
}
