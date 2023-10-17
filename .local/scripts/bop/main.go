package main

import (
	"context"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
	"strings"

	"github.com/zmb3/spotify/v2"
	spotifyauth "github.com/zmb3/spotify/v2/auth"
)

var helpMessage = `
Usage:
  bop -command search -query "super shy"

Available commands:
  - search
`

func newStateHash() string {
	var letterRunes = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

	b := make([]rune, 10)
	for i := range b {
		b[i] = letterRunes[rand.Intn(len(letterRunes))]
	}
	return string(b)
}

const PORT = 8888

func main() {
	app, err := initializeApp()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: \n%v", err)
		os.Exit(1)
	}

	redirectURL := fmt.Sprintf("http://localhost:%d/callback", PORT)
	redirectComps := strings.Split(redirectURL, "/")
	redirectPath := fmt.Sprintf("/%s", redirectComps[len(redirectComps)-1])

	state := newStateHash()
	auth := spotifyauth.New(spotifyauth.WithRedirectURL(redirectURL), spotifyauth.WithScopes(spotifyauth.ScopeUserReadPrivate, spotifyauth.ScopeUserModifyPlaybackState), spotifyauth.WithClientID(app.clientId))
	url := auth.AuthURL(state)
	fmt.Printf("Authenticate using the following link: \n%s\n\n", url)

	router := http.NewServeMux()
	router.HandleFunc(redirectPath, func(w http.ResponseWriter, r *http.Request) {
		token, err := auth.Token(r.Context(), state, r)
		if err != nil {
			http.Error(w, "Couldn't get token", http.StatusNotFound)
			return
		}
		// create a client using the specified token
		client := spotify.New(auth.Client(r.Context(), token))
		err = client.Next(context.Background())
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: \n%v", err)
			return
		}
	})

	fmt.Println("Waiting for requests")
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", PORT), router))
}
