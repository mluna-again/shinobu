package main

import (
	"strings"

	"github.com/charmbracelet/bubbles/table"
)

func hasAllLetters(session, query string) bool {
	session = strings.TrimSpace(session)
	seen := map[rune]int{}

	for _, letter := range query {
		if _, ok := seen[letter]; ok {
			seen[letter]++
			continue
		}

		seen[letter] = 1
	}

	for _, letter := range session {
		if _, ok := seen[letter]; ok {
			seen[letter]--
			continue
		}
	}

	for _, value := range seen {
		if value > 0 {
			return false
		}
	}

	return true
}

func (m *model) fuzzyFind() {
	if len(m.input.Value()) == 0 {
		m.filtered = m.app.lines
		return
	}

	m.filtered = []string{}

	for _, session := range m.app.lines {
		if session != "" && hasAllLetters(session, m.input.Value()) {
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
