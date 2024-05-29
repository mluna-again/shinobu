package internal

import (
	"fmt"
	"strings"
	"unicode/utf8"

	"github.com/charmbracelet/lipgloss"
)

func CenterInScreen(w int, h int, msg string) string {
	return lipgloss.Place(w, h, lipgloss.Center, lipgloss.Center, msg)
}

func CenterBanner(w int, banner string) string {
	paddCount := (w - lipgloss.Width(banner)) / 2
	padd := strings.Repeat(" ", paddCount)
	return lipgloss.JoinHorizontal(lipgloss.Center, padd, banner, padd)
}

func CatSays(msg string) string {
	border := "━"
	cat := `
(\ (\
(„• ֊ •„)
━O━O━━━━━━━━━`
	minborderlen := 13 // upperborder len
	borderlen := utf8.RuneCount([]byte(msg))
	if borderlen < minborderlen {
		borderlen = minborderlen
	}

	if borderlen > minborderlen {
		cat = fmt.Sprintf("%s%s", cat, strings.Repeat(border, borderlen-minborderlen))
	}

	content := lipgloss.JoinVertical(lipgloss.Top, cat, msg, strings.Repeat(border, borderlen))

	return content
}

func CatSaysSerious(msg string) string {
	border := "━"
	cat := `
(\ (\
(„• - •„)
━O━O━━━━━━━━━`
	minborderlen := 13 // upperborder len
	borderlen := utf8.RuneCount([]byte(msg))
	if borderlen < minborderlen {
		borderlen = minborderlen
	}

	if borderlen > minborderlen {
		cat = fmt.Sprintf("%s%s", cat, strings.Repeat(border, borderlen-minborderlen))
	}

	content := lipgloss.JoinVertical(lipgloss.Top, cat, msg, strings.Repeat(border, borderlen))

	return content
}
