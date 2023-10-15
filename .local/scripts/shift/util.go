package main

import (
	"fmt"
	"strings"
)

func shouldGoToTop(msg string) bool {
	ignore := []string{"ctrl+n", "ctrl+p", "up", "down", "tab", "shift+tab"}
	for _, s := range ignore {
		if s == msg {
			return false
		}
	}

	return true
}

func (app *app) cleanUpModeParams(params string) string {
	for _, mode := range app.modes {
		prefix := fmt.Sprintf("%s ", mode.prefix)
		if mode.prefix != "" && strings.HasPrefix(params, prefix) {
			return strings.TrimPrefix(params, mode.prefix)
		}
	}
	return params
}

func (app *app) cleanUpModeParamsForView(params string, query string) string {
	for _, mode := range app.modes {
		realPrefix := fmt.Sprintf("%s ", mode.prefix)
		if strings.HasPrefix(query, realPrefix) {
			return strings.Replace(params, realPrefix, "", 1)
		}
	}
	return params
}

func (m model) inputWidth() int {
	if m.mode == switchSession {
		return m.termWidth - 4 - len(m.counterText())
	}

	return m.termWidth - 4
}

func (m model) counterText() string {
	total := len(m.app.lines)
	filtered := len(m.filtered)
	return fmt.Sprintf("%02d/%02d ", filtered, total)
}
