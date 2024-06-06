package queueview

import (
	"fmt"
	"io"
	"strings"
	"unicode/utf8"

	"github.com/charmbracelet/bubbles/list"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	zone "github.com/lrstanley/bubblezone"
)

const COVERSIZE = 10

type itemDelegate struct {
	height int
}

func (d itemDelegate) Height() int  { return d.height }
func (d itemDelegate) Spacing() int { return 0 }
func (d itemDelegate) Update(_ tea.Msg, m *list.Model) tea.Cmd {
	return nil
}
func (d itemDelegate) Render(w io.Writer, m list.Model, index int, listItem list.Item) {
	i, ok := listItem.(item)
	if !ok {
		return
	}
	isSelected := index == m.Index()
	selectedBG := iconStyle.GetBackground()
	if isSelected {
		selectedBG = selectedItemStyle.GetBackground()
	}

	fn := itemStyle.Render
	if isSelected {
		fn = selectedItemStyle.Render
	}

	icon := strings.Trim(i.Ascii, "\n")
	if icon == "" {
		icon = `//////////
//////////
//////////
//////////
//////////`
	}

	wi := m.Width() - COVERSIZE
	details := lipgloss.JoinVertical(lipgloss.Left, fitStr(wi, fmt.Sprintf(" %s", i.Name)), fitStr(wi, fmt.Sprintf(" %s", i.Artist)), fitStr(wi, fmt.Sprintf(" %s", i.Duration)))
	if i.IsPlaying {
		details = lipgloss.JoinVertical(lipgloss.Left, details, " Playing...")
	}
	details = fn(details)

	likedIcon := " ♥ "
	if i.Liked {
		likedIcon = "  "
	}
	liked := lipgloss.PlaceVertical(d.Height(), lipgloss.Center, zone.Mark(fmt.Sprintf("%s-liked", i.ID), likedIcon))
	likedW := lipgloss.Width(liked)
	if isSelected {
		liked = fn(liked)
	}

	if isSelected {
		details = lipgloss.Place(m.Width()-COVERSIZE-likedW, d.Height(), lipgloss.Top, lipgloss.Left, details, lipgloss.WithWhitespaceBackground(selectedBG))
	} else {
		details = lipgloss.Place(m.Width()-COVERSIZE-likedW, d.Height(), lipgloss.Top, lipgloss.Left, details, lipgloss.WithWhitespaceBackground(lipgloss.NoColor{}))
	}

	str := lipgloss.JoinHorizontal(lipgloss.Top, icon, details, liked)

	fmt.Fprint(w, zone.Mark(i.ID, str))
}

func fitStr(width int, str string) string {
	if width <= 3 {
		return str
	}

	if utf8.RuneCount([]byte(str)) >= width-3 {
		return string([]rune(str)[0 : width-3])
	}

	return str
}
