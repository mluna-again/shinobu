package main

import (
	"io"
	"os"
	"strings"
)

func (app *app) loadLines() error {
	output, err := io.ReadAll(os.Stdin)
	if err != nil {
		return err
	}

	app.lines = strings.Split(string(output), "\n")

	return nil
}
