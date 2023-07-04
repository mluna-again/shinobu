package main

import (
	"strings"

	"github.com/charmbracelet/bubbles/table"
)

func (m *model) fuzzyFind() {
	if len(m.input.Value()) == 0 {
		m.filtered = m.app.lines
		return
	}

	m.filtered = []string{}

	for _, session := range m.app.lines {
		if session != "" && strings.Contains(strings.TrimSpace(session), strings.TrimSpace(m.input.Value())) {
			m.filtered = append(m.filtered, session)
		}
	}
}

func sessionsToRows(sessions []string) []table.Row {
	rows := []table.Row{}

	for _, session := range sessions {
		rows = append(rows, table.Row{session})
	}

	return rows
}
