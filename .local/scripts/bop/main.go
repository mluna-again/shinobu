package main

import (
	"fmt"
	"os"
)

var helpMessage = `
Usage:
  bop -command search -query "super shy"

Available commands:
  - search
`

func main() {
	app, err := initializeApp()
	if app.helpRequested {
		fmt.Println(helpMessage)
		os.Exit(0)
	}

	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: \n%v", err)
		return
	}

	var cmdErr error
	switch app.command {
	case "search":
		err := app.search()
		if err != nil {
			cmdErr = err
		}

	case "play":
		err := app.playSong()
		if err != nil {
			cmdErr = err
		}

	default:
		fmt.Fprintf(os.Stderr, "Invalid command: %s", app.command)
		os.Exit(1)
	}

	if cmdErr != nil {
		fmt.Fprintf(os.Stderr, "Error: \n%v", cmdErr)
		os.Exit(1)
	}
}
