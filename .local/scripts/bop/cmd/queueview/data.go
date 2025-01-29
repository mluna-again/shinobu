package queueview

import (
	"bop/internal"
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"sync"
	"time"

	tea "github.com/charmbracelet/bubbletea"
)

type BopItem struct {
	ID            string `json:"id"`
	Name          string `json:"display_name"`
	Artist        string `json:"artist"`
	URL           string `json:"image_url"`
	Duration      string `json:"duration"`
	IsPlaying     bool   `json:"is_playing"`
	CurrentSecond int    `json:"current_second"`
	TotalSeconds  int    `json:"total_seconds"`
	Liked         bool   `json:"liked"`
}

var BOP = fmt.Sprintf("http://%s:%s", os.Getenv("BOP_HOST"), os.Getenv("PORT"))

type reloadQueueMsg struct {
	timestamp string
}

type queueLoadedMsg struct {
	queue []item
	err   error
}

func (m model) loadQueue() tea.Msg {
	resp, err := http.DefaultClient.Get(fmt.Sprintf("%s/queue", BOP))
	if err != nil {
		return queueLoadedMsg{err: err}
	}
	defer resp.Body.Close()

	var data []BopItem
	d := json.NewDecoder(resp.Body)
	err = d.Decode(&data)
	if err != nil {
		return queueLoadedMsg{err: err}
	}

	items := []item{}
	for _, s := range data {
		items = append(items, item{
			ID:            s.ID,
			Name:          s.Name,
			Artist:        s.Artist,
			Duration:      s.Duration,
			URL:           s.URL,
			IsPlaying:     s.IsPlaying,
			CurrentSecond: s.CurrentSecond,
			TotalSeconds:  s.TotalSeconds,
			Liked:         s.Liked,
		})
	}

	return queueLoadedMsg{queue: items}
}

type songLikedOrDislikedMsg struct {
	liked  bool
	err    error
	songID string
}

func (m model) toggleSongLike(song item) tea.Cmd {
	return func() tea.Msg {
		liked := true
		url := fmt.Sprintf("%s/addToLiked", BOP)
		if song.Liked {
			url = fmt.Sprintf("%s/removeFromLiked", BOP)
			liked = false
		}

		client := HTTPClient()
		data, err := json.Marshal(map[string]string{"ID": song.ID})
		if err != nil {
			return songLikedOrDislikedMsg{err: err}
		}

		body := bytes.NewBuffer(data)
		resp, err := client.Post(url, "application/json", body)
		if err != nil {
			return songLikedOrDislikedMsg{err: err}
		}
		defer resp.Body.Close()
		if resp.StatusCode != http.StatusOK {
			return songLikedOrDislikedMsg{err: errors.New("server said no")}
		}

		return songLikedOrDislikedMsg{
			songID: song.ID,
			liked:  liked,
		}
	}
}

type newThumbnailMsg struct {
	ascii string
	ID    string
}

type thumbnailsLoadedMsg struct{}

func (m model) loadThumbnails(prog *tea.Program) {
	msg := m.loadQueue()
	prog.Send(msg)

	res, ok := msg.(queueLoadedMsg)
	if !ok {
		panic("could not cast queue msg")
	}
	if res.err != nil {
		return
	}

	wg := sync.WaitGroup{}
	for _, song := range res.queue {
		wg.Add(1)
		go func(s item) {
			defer wg.Done()
			if s.URL == "" {
				return
			}

			resp, err := http.DefaultClient.Get(s.URL)
			if err != nil {
				return
			}
			defer resp.Body.Close()
			file, err := os.CreateTemp("", "bop-cover-*")
			if err != nil {
				fmt.Fprintf(os.Stderr, "could not create temp file\n")
				return
			}
			defer func() {
				err := file.Close()
				if err != nil {
					fmt.Fprintf(os.Stderr, "could not close file %s\n", file.Name())
					return
				}
				err = os.Remove(file.Name())
				if err != nil {
					fmt.Fprintf(os.Stderr, "could not delete temp file %s\n", file.Name())
					return
				}
			}()
			_, err = io.Copy(file, resp.Body)
			if err != nil {
				return
			}

			output, err := internal.GetChafaCmd(file.Name(), 10).Output()
			if err != nil {
				return
			}

			prog.Send(newThumbnailMsg{
				ID:    s.ID,
				ascii: string(output),
			})
		}(song)
	}

	wg.Wait()
	prog.Send(thumbnailsLoadedMsg{})
}

func HTTPClient() http.Client {
	c := http.Client{}
	c.Timeout = time.Second * 3

	return c
}
