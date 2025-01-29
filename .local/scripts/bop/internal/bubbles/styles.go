package bubbles

import (
	"bop/internal"

	"github.com/charmbracelet/lipgloss"
)

var timeStyle = lipgloss.NewStyle().
	Foreground(internal.KanagawaDragon.FGLight).
	PaddingLeft(1).
	PaddingRight(1)

var artistStyle = lipgloss.NewStyle().
	Foreground(internal.KanagawaDragon.FGLight).
	MarginBottom(1)

var helpStyle = lipgloss.NewStyle().
	Foreground(internal.KanagawaDragon.BGLight).
	PaddingLeft(1).
	PaddingRight(1)
