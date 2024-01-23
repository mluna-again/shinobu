package main

import (
	"context"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
	"os/exec"
	"strings"

	"html/template"

	"github.com/zmb3/spotify/v2"
	spotifyauth "github.com/zmb3/spotify/v2/auth"
)

type loginSuccess struct {
	Username string
}

var helpMessage = `
Usage:
  bop -command search -query "super shy"

Available commands:
  - search
`

func randomString() string {
	var letterRunes = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

	b := make([]rune, 10)
	for i := range b {
		b[i] = letterRunes[rand.Intn(len(letterRunes))]
	}
	return string(b)
}

const PORT = 8888

var scopes = []string{
	spotifyauth.ScopeUserReadPrivate,
	spotifyauth.ScopeUserModifyPlaybackState,
	spotifyauth.ScopeUserReadCurrentlyPlaying,
	spotifyauth.ScopeUserReadPlaybackState,
	spotifyauth.ScopeUserLibraryRead,
	spotifyauth.ScopeUserLibraryModify,
}

func main() {
	app, err := initializeApp()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: \n%v", err)
		os.Exit(1)
	}

	redirectURL := fmt.Sprintf("http://localhost:%d/callback", PORT)
	redirectComps := strings.Split(redirectURL, "/")
	redirectPath := fmt.Sprintf("/%s", redirectComps[len(redirectComps)-1])

	state := randomString()
	auth := spotifyauth.New(spotifyauth.WithRedirectURL(redirectURL), spotifyauth.WithScopes(scopes...), spotifyauth.WithClientID(app.clientId))
	url := auth.AuthURL(state)
	fmt.Printf("Authenticate using the following link: \n%s\n\n", url)
	cmd := exec.Command("firefox", "-new-tab", url)
	_ = cmd.Run()

	router := http.NewServeMux()

	fs := http.FileServer(http.Dir("./static"))
	router.Handle("/files/", http.StripPrefix("/files/", fs))

	router.HandleFunc(redirectPath, func(w http.ResponseWriter, r *http.Request) {
		if app.client != nil {
			w.WriteHeader(http.StatusBadRequest)
			_, err := w.Write([]byte("already authenticated"))
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
			}
			return
		}

		token, err := auth.Token(context.Background(), state, r)
		if err != nil {
			http.Error(w, "Couldn't get token", http.StatusNotFound)
			return
		}
		// create a client using the specified token
		client := spotify.New(auth.Client(context.Background(), token))
		app.client = client
		tmpl, err := template.New("login_success.html").ParseFiles("login_success.html")
		if err != nil {
			_, _ = w.Write([]byte("user authenticated"))
		} else {
			// nah
			data := loginSuccess{}
			user, err := app.client.CurrentUser(r.Context())
			if err != nil {
				data.Username = "<an error occurred while loading your username ok>"
			} else {
				data.Username = user.DisplayName
			}
			err = tmpl.Execute(w, data)
			if err != nil {
				_, _ = w.Write([]byte(err.Error()))
				log.Println("user (maybe) authenticated")
				return
			}
		}

		log.Println("user authenticated")
	})

	router.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})
	router.HandleFunc("/search", app.checkTokenMiddleware(loggingMiddleware(app.search)))
	router.HandleFunc("/play", app.checkTokenMiddleware(loggingMiddleware(app.playSong)))
	router.HandleFunc("/pause", app.checkTokenMiddleware(loggingMiddleware(app.pause)))
	router.HandleFunc("/next", app.checkTokenMiddleware(loggingMiddleware(app.next)))
	router.HandleFunc("/prev", app.checkTokenMiddleware(loggingMiddleware(app.prev)))
	router.HandleFunc("/status", app.checkTokenMiddleware(loggingMiddleware(app.status)))
	router.HandleFunc("/restart", app.checkTokenMiddleware(loggingMiddleware(app.restart)))
	router.HandleFunc("/queue", app.checkTokenMiddleware(loggingMiddleware(app.queue)))
	router.HandleFunc("/addToLiked", app.checkTokenMiddleware(loggingMiddleware(app.addToLiked)))
	router.HandleFunc("/removeFromLiked", app.checkTokenMiddleware(loggingMiddleware(app.removeFromLiked)))

	fmt.Println("Waiting for requests")
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%d", PORT), router))
}
