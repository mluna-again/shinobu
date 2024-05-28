package queueview

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"sync"

	tea "github.com/charmbracelet/bubbletea"
)

type BopItem struct {
	ID        string `json:"id"`
	Name      string `json:"display_name"`
	Artist    string `json:"artist"`
	URL       string `json:"image_url"`
	Duration  string `json:"duration"`
	IsPlaying bool   `json:"is_playing"`
}

var BOP = "http://localhost:8888"

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
			ID:        s.ID,
			Name:      s.Name,
			Artist:    s.Artist,
			Duration:  s.Duration,
			URL:       s.URL,
			IsPlaying: s.IsPlaying,
		})
	}

	return queueLoadedMsg{queue: items}
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

			output, err := exec.Command("chafa", "-s", "10x10", file.Name()).Output()
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
