package main

import (
	"context"
	"flag"
	"os"

	"errors"

	"github.com/zmb3/spotify/v2"
	spotifyauth "github.com/zmb3/spotify/v2/auth"
	"golang.org/x/oauth2/clientcredentials"
)

type app struct {
	command       string
	results       *spotify.SearchResult
	client        *spotify.Client
	helpRequested bool
	query         string
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
	}

	err := a.newClient(clientId, secret)
	if err != nil {
		return nil, err
	}

	return a, nil
}

func (app *app) newClient(client, secret string) error {
	config := &clientcredentials.Config{
		ClientID:     client,
		ClientSecret: secret,
		TokenURL:     spotifyauth.TokenURL,
		Scopes:       []string{spotifyauth.ScopeUserReadPrivate, spotifyauth.ScopeUserModifyPlaybackState, spotifyauth.ScopeStreaming},
	}
	token, err := config.Token(context.Background())
	if err != nil {
		return err
	}

	httpClient := spotifyauth.New().Client(context.Background(), token)
	app.client = spotify.New(httpClient)

	return nil
}
