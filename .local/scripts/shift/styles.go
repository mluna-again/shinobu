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

var everforest = Colors{
	darkLight: "#2E383C",
	dark:      "#272E33",
	darker:    "#1E2326",
	light:     "#D3C6AA",
	yellow:    "#DBBC7F",
}

var gruvbox = Colors{
	darkLight: "#504945",
	dark:      "#3c3836",
	darker:    "#1d2021",
	light:     "#d5c4a1",
	yellow:    "#d79921",
}

var catppuccin = Colors{
	darkLight: "#24273a",
	dark:      "#1e2030",
	darker:    "#181926",
	light:     "#ed8796",
	yellow:    "#f4dbd6",
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

var everforestStyles = Styles{
	header:      lipgloss.NewStyle().Background(lipgloss.Color(everforest.darker)).Foreground(lipgloss.Color(everforest.light)).Bold(false),
	prompt:      lipgloss.NewStyle().Background(lipgloss.Color(everforest.darker)).Foreground(lipgloss.Color(everforest.light)).Bold(false),
	headerTitle: lipgloss.NewStyle().Background(lipgloss.Color(everforest.yellow)).Foreground(lipgloss.Color(everforest.dark)).Bold(false),
	line: lipgloss.NewStyle().
		Background(lipgloss.Color(everforest.darkLight)).
		Foreground(lipgloss.Color(everforest.light)).
		PaddingLeft(1).
		Bold(false),
	selectedLine: lipgloss.NewStyle().
		Background(lipgloss.Color(everforest.yellow)).
		Foreground(lipgloss.Color(everforest.dark)).
		Bold(false),
}

var gruvboxStyles = Styles{
	header:      lipgloss.NewStyle().Background(lipgloss.Color(gruvbox.darker)).Foreground(lipgloss.Color(gruvbox.light)).Bold(false),
	prompt:      lipgloss.NewStyle().Background(lipgloss.Color(gruvbox.darker)).Foreground(lipgloss.Color(gruvbox.light)).Bold(false),
	headerTitle: lipgloss.NewStyle().Background(lipgloss.Color(gruvbox.yellow)).Foreground(lipgloss.Color(gruvbox.dark)).Bold(false),
	line: lipgloss.NewStyle().
		Background(lipgloss.Color(gruvbox.darkLight)).
		Foreground(lipgloss.Color(gruvbox.light)).
		PaddingLeft(1).
		Bold(false),
	selectedLine: lipgloss.NewStyle().
		Background(lipgloss.Color(gruvbox.yellow)).
		Foreground(lipgloss.Color(gruvbox.dark)).
		Bold(false),
}

var catppuccinStyles = Styles{
	header:      lipgloss.NewStyle().Background(lipgloss.Color(catppuccin.darker)).Foreground(lipgloss.Color(catppuccin.light)).Bold(false),
	prompt:      lipgloss.NewStyle().Background(lipgloss.Color(catppuccin.darker)).Foreground(lipgloss.Color(catppuccin.light)).Bold(false),
	headerTitle: lipgloss.NewStyle().Background(lipgloss.Color(catppuccin.yellow)).Foreground(lipgloss.Color(catppuccin.dark)).Bold(false),
	line: lipgloss.NewStyle().
		Background(lipgloss.Color(catppuccin.darkLight)).
		Foreground(lipgloss.Color(catppuccin.light)).
		PaddingLeft(1).
		Bold(false),
	selectedLine: lipgloss.NewStyle().
		Background(lipgloss.Color(catppuccin.yellow)).
		Foreground(lipgloss.Color(catppuccin.dark)).
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

	case "everforest":
		app.theme = everforestStyles

	case "gruvbox":
		app.theme = gruvboxStyles

	case "catppuccin":
		app.theme = catppuccinStyles

	default:
		app.theme = kanagawaDragonStyles
	}
}
