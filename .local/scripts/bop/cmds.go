package main

import (
	"flag"
	"os"

	"errors"

	"github.com/zmb3/spotify/v2"
)

type app struct {
	command       string
	results       *spotify.SearchResult
	client        *spotify.Client
	helpRequested bool
	query         string
	clientId      string
	secret        string
}

var (
	noClientError = errors.New("No SPOTIFY_ID found")
	noSecretError = errors.New("No SPOTIFY_SECRET found")
)

var cmdFlag string
var helpFlag bool
var queryFlag string

func initializeApp() (*app, error) {
	clientId := os.Getenv("SPOTIFY_ID")
	if clientId == "" {
		return nil, noClientError
	}

	secret := os.Getenv("SPOTIFY_SECRET")
	if secret == "" {
		return nil, noSecretError
	}

	flag.StringVar(&cmdFlag, "command", "search", "action")
	flag.BoolVar(&helpFlag, "help", false, "display help")
	flag.StringVar(&queryFlag, "query", "", "query")
	flag.Parse()

	a := &app{
		command:       cmdFlag,
		query:         queryFlag,
		helpRequested: helpFlag,
		clientId:      clientId,
		secret:        secret,
	}

	return a, nil
}
