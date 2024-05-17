package internal

import (
	"strings"

	"github.com/charmbracelet/lipgloss"
)

func CenterBanner(w int, banner string) string {
	paddCount := (w - lipgloss.Width(banner)) / 2
	padd := strings.Repeat(" ", paddCount)
	return lipgloss.JoinHorizontal(lipgloss.Center, padd, banner, padd)
}
