package main

import (
	"context"
	"errors"
	"fmt"
	"os"

	"github.com/zmb3/spotify/v2"
)

var (
	noSearchQueryError = errors.New("No query provided")
)

func (app *app) search() error {
	if app.query == "" {
		return noSearchQueryError
	}
	query := os.Args[1]

	results, err := app.client.Search(context.Background(), query, spotify.SearchTypeTrack|spotify.SearchTypeAlbum)
	if err != nil {
		return err
	}

	app.results = results

	app.printResults()
	return nil
}

func (app *app) printResults() {
	if app.results.Tracks != nil {
		for i, song := range app.results.Tracks.Tracks {
			if i >= 5 {
				break
			}
			fmt.Printf("%s %s by %s\n", song.URI, song.Name, song.Artists[0].Name)
		}
	}

	if app.results.Albums != nil {
		for i, album := range app.results.Albums.Albums {
			if i >= 5 {
				break
			}
			fmt.Printf("%s %s by %s\n", album.URI, album.Name, album.Artists[0].Name)
		}
	}

	if app.results.Playlists != nil {
		for i, playlist := range app.results.Playlists.Playlists {
			if i >= 5 {
				break
			}
			fmt.Printf("%s %s by %s\n", playlist.URI, playlist.Name, playlist.Owner.DisplayName)
		}
	}
}
