package main

import (
	"github.com/charmbracelet/bubbles/table"
	"github.com/sahilm/fuzzy"
)

func (m *model) fuzzyFind() {
	if len(m.input.Value()) == 0 {
		m.filtered = m.app.lines
		return
	}

	query := m.input.Value()
	matches := fuzzy.Find(query, m.app.lines)

	m.filtered = []string{}

	for _, match := range matches {
		m.filtered = append(m.filtered, match.Str)
	}
}

func sessionsToRows(sessions []string) []table.Row {
	rows := []table.Row{}

	for _, session := range sessions {
		rows = append(rows, table.Row{session})
	}

	return rows
}
