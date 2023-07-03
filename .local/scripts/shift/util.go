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
		if mode.prefix != "" && strings.HasPrefix(params, mode.prefix) {
			return strings.TrimPrefix(params, mode.prefix)
		}
	}
	return params
}

func (app *app) cleanUpModeParamsForView(params string) string {
	for _, mode := range app.modes {
		realPrefix := fmt.Sprintf("%s ", mode.prefix)
		if mode.prefix != "" && strings.Contains(params, realPrefix) {
			return strings.Replace(params, realPrefix, "", 1)
		}
	}
	return params
}
