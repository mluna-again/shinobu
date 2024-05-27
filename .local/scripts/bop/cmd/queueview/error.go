package queueview

import (
	"fmt"
	"strings"
	"unicode/utf8"

	"github.com/charmbracelet/lipgloss"
)

func catSays(msg string) string {
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

func catSaysSerious(msg string) string {
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
