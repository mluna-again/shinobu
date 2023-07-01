package main

import (
	"errors"
	"strings"
)

func splitSessions(sessions []string) ([]string, error) {
	newSessions := make([]string, len(sessions))

	for i, s := range sessions {
		cols := strings.Split(s, " ")
		if len(cols) < 1 {
			return []string{}, errors.New("wrong session format!")
		}

		name := cols[0]
		newSessions[i] = strings.TrimRight(name, ":")
	}

	return newSessions, nil
}

func (m *model) fuzzyFind() {
	if len(m.input.Value()) == 0 {
		m.filtered = m.sessions
		return
	}

	m.filtered = []string{}

	for _, session := range m.sessions {
		if strings.Contains(strings.TrimSpace(session), strings.TrimSpace(m.input.Value())) {
			m.filtered = append(m.filtered, session)
		}
	}
}
