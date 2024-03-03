package main

import (
	"context"
	"flag"
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"time"

	"html/template"

	"github.com/go-chi/chi/v5"
	"github.com/zmb3/spotify/v2"
	spotifyauth "github.com/zmb3/spotify/v2/auth"
)

var portFlag string

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

var scopes = []string{
	spotifyauth.ScopeUserReadPrivate,
	spotifyauth.ScopeUserModifyPlaybackState,
	spotifyauth.ScopeUserReadCurrentlyPlaying,
	spotifyauth.ScopeUserReadPlaybackState,
	spotifyauth.ScopeUserLibraryRead,
	spotifyauth.ScopeUserLibraryModify,
}

func main() {
	flag.StringVar(&portFlag, "port", "8888", "bop's server port")
	flag.Parse()
	port := portFlag
	if port == "" {
		port = "8888"
	}

	app, err := initializeApp()
	defer app.cleanup()

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	go func() {
		<-c
		app.cleanup()
		os.Exit(1)
	}()

	if err != nil {
		app.errLogger.Fatal(err)
	}
	redirectURL := fmt.Sprintf("http://localhost:%s/callback", port)
	redirectComps := strings.Split(redirectURL, "/")
	redirectPath := fmt.Sprintf("/%s", redirectComps[len(redirectComps)-1])

	state := randomString()
	auth := spotifyauth.New(spotifyauth.WithRedirectURL(redirectURL), spotifyauth.WithScopes(scopes...), spotifyauth.WithClientID(app.clientId))
	url := auth.AuthURL(state)

	t, err := app.retrieveToken(auth)
	if err == nil {
		app.client = spotify.New(auth.Client(context.Background(), t))
		app.logger.Info("Authenticated")
	} else {
		app.logger.Infof("Could not retrieve token: %s", err.Error())
		app.logger.Infof("Authenticate using the following link: \n%s\n\n", url)
	}

	router := chi.NewRouter()

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
				app.logger.Info("user (maybe) authenticated")
				return
			}
		}

		app.logger.Info("user authenticated")
		err = app.saveToken(token)
		if err != nil {
			app.errLogger.Info(err)
		}
	})

	router.Get("/health", app.health)
	router.Get("/search", app.checkTokenMiddleware(app.loggingMiddleware(app.search)))
	router.Post("/play", app.checkTokenMiddleware(app.loggingMiddleware(app.playSong)))
	router.Post("/pause", app.checkTokenMiddleware(app.loggingMiddleware(app.pause)))
	router.Post("/next", app.checkTokenMiddleware(app.loggingMiddleware(app.next)))
	router.Post("/prev", app.checkTokenMiddleware(app.loggingMiddleware(app.prev)))
	router.Get("/status", app.checkTokenMiddleware(app.loggingMiddleware(app.status)))
	router.Post("/restart", app.checkTokenMiddleware(app.loggingMiddleware(app.restart)))
	router.Get("/queue", app.checkTokenMiddleware(app.loggingMiddleware(app.queue)))
	router.Post("/addToLiked", app.checkTokenMiddleware(app.loggingMiddleware(app.addToLiked)))
	router.Post("/removeFromLiked", app.checkTokenMiddleware(app.loggingMiddleware(app.removeFromLiked)))
	router.Get("/devices", app.checkTokenMiddleware(app.loggingMiddleware(app.listDevices)))
	router.Post("/setDevice", app.checkTokenMiddleware(app.loggingMiddleware(app.setDevice)))
	router.Get("/*", func(w http.ResponseWriter, r *http.Request) {
		app.sendNotFound(w, r)
	})

	server := http.Server{
		ReadTimeout:       1 * time.Second,
		WriteTimeout:      1 * time.Second,
		IdleTimeout:       30 * time.Second,
		ReadHeaderTimeout: 2 * time.Second,
		Handler:           router,
		Addr:              fmt.Sprintf(":%s", port),
	}

	app.logger.Infof("Waiting for requests at port %s", port)
	app.errLogger.Fatal(server.ListenAndServe())
}
