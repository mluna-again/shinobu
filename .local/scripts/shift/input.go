package main

import (
	"io"
	"os"
	"strings"
)

type modeType int

const (
	switchSession = iota
	createSession
	renameSession
)

type mode struct {
	prompt string
	title  string
	name   string
	mType  modeType
	params string
	prefix string
}

func (app *app) switchMode() mode {
	return mode{
		app.startingModeIcon,
		app.startingModeTitle,
		"switch",
		switchSession,
		"",
		"",
	}
}

func (app *app) loadLines(input string) error {
	if input == "" {
		output, err := io.ReadAll(os.Stdin)
		if err != nil {
			return err
		}
		input = string(output)
	}

	lines := strings.Split(input, "\n")
	nonEmpty := []string{}
	for _, line := range lines {
		if line == "" {
			continue
		}

		nonEmpty = append(nonEmpty, line)
	}

	app.lines = nonEmpty
	return nil
}

func (app *app) loadModes() {
	modes := []mode{
		{
			app.startingModeIcon,
			app.startingModeTitle,
			"switch",
			switchSession,
			"",
			"",
		},
		{
			"  ",
			" New session ",
			"create",
			createSession,
			"",
			"c",
		},
		{
			" 󰔤 ",
			" Rename session ",
			"rename",
			renameSession,
			"",
			"r",
		},
	}

	for i, mode := range modes {
		if mode.name == app.startingMode {
			modes[i].title = app.startingModeTitle
			modes[i].prompt = app.startingModeIcon
		}
	}

	app.modes = modes
}
