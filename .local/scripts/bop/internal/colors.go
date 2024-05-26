package internal

import "github.com/charmbracelet/lipgloss"

var BG = lipgloss.Color("")

type Theme struct {
	BG        lipgloss.Color
	BGLight   lipgloss.Color
	BGDark    lipgloss.Color
	FG        lipgloss.Color
	FGLight   lipgloss.Color
	Primary   lipgloss.Color
	Secondary lipgloss.Color
}

var KanagawaDragon = Theme{
	BGLight:   lipgloss.Color("#181616"),
	BG:        lipgloss.Color("#1D1C19"),
	BGDark:    lipgloss.Color("#12120f"),
	FG:        lipgloss.Color("#c5c9c5"),
	FGLight:   lipgloss.Color("#9e9b93"),
	Primary:   lipgloss.Color("#c4b28a"),
	Secondary: lipgloss.Color("#c4746e"),
}
