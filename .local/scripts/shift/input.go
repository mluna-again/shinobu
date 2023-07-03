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
		"  ",
		" Switch session ",
		"switch",
		switchSession,
		"",
		"",
	}
}

func (app *app) loadLines() error {
	output, err := io.ReadAll(os.Stdin)
	if err != nil {
		return err
	}

	app.lines = strings.Split(string(output), "\n")

	return nil
}

func (app *app) loadModes() {
	app.modes = []mode{
		{
			"  ",
			" Switch session ",
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
}
