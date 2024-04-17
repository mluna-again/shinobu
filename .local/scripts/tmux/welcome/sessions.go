package main

import (
	"fmt"
	"io"
	"strings"
	"unicode/utf8"

	"github.com/charmbracelet/bubbles/list"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type item struct {
	name            string
	index           string
	numberOfWindows int
}

func (i item) FilterValue() string { return i.name }

type itemDelegate struct{}

func (d itemDelegate) Height() int                             { return 1 }
func (d itemDelegate) Spacing() int                            { return 0 }
func (d itemDelegate) Update(_ tea.Msg, _ *list.Model) tea.Cmd { return nil }
func (d itemDelegate) Render(w io.Writer, m list.Model, index int, listItem list.Item) {
	i, ok := listItem.(item)
	if !ok {
		return
	}

	windows := fmt.Sprintf("%d windows", i.numberOfWindows)
	if i.numberOfWindows > 99 {
		windows = "a lot of windows"
	}

	nameWidth := sessionItem.GetWidth() - lipgloss.Width(windows)
	name := i.name
	if utf8.RuneCount([]byte(name)) > nameWidth {
		name = name[:nameWidth]
	}
	diff := sessionItem.GetWidth() - (lipgloss.Width(name) + lipgloss.Width(windows))
	if diff < 0 {
		diff = 0
	}
	padd := strings.Repeat(" ", diff)

	str := fmt.Sprintf("%s%s%s", name, padd, windows)

	fn := sessionItem.Render
	if index == m.Index() {
		fn = func(s ...string) string {
			return selectedItemStyle.Render(strings.Join(s, " "))
		}
	}

	fmt.Fprint(w, fn(str))
}
