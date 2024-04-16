package main

import (
	"fmt"
	"io"
	"strings"
	"time"
	"unicode/utf8"

	"github.com/charmbracelet/bubbles/list"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

type item struct {
	name           string
	index          string
	lastAttachedAt time.Time
}

func (i item) FilterValue() string { return "" }

type itemDelegate struct{}

func (d itemDelegate) Height() int                             { return 1 }
func (d itemDelegate) Spacing() int                            { return 0 }
func (d itemDelegate) Update(_ tea.Msg, _ *list.Model) tea.Cmd { return nil }
func (d itemDelegate) Render(w io.Writer, m list.Model, index int, listItem list.Item) {
	i, ok := listItem.(item)
	if !ok {
		return
	}

	dateFormat := "January 02, 2006"
	nameWidth := sessionItem.GetWidth() - lipgloss.Width(dateFormat)
	date := i.lastAttachedAt.Format(dateFormat)
	name := i.name
	if utf8.RuneCount([]byte(name)) > nameWidth {
		name = name[:nameWidth]
	}
	diff := sessionItem.GetWidth() - (lipgloss.Width(name) + lipgloss.Width(date))
	if diff < 0 {
		diff = 0
	}
	padd := strings.Repeat(" ", diff)

	str := fmt.Sprintf("%s%s%s", name, padd, date)

	fn := sessionItem.Render
	if index == m.Index() {
		fn = func(s ...string) string {
			return selectedItemStyle.Render(strings.Join(s, " "))
		}
	}

	fmt.Fprint(w, fn(str))
}
