package selector

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"

	tea "github.com/charmbracelet/bubbletea"
)

var BOP = "http://localhost:8888"

type addedToQueue struct {
	err error
}

type AddToQueuePayload struct {
	IDS []string `json:"ids"`
}

func (m model) addToQueue() tea.Msg {
	if len(m.songs.selectedSongs) == 0 {
		return addedToQueue{}
	}

	data := AddToQueuePayload{
		IDS: []string{},
	}
	payload, err := json.Marshal(&data)
	if err != nil {
		return addedToQueue{err}
	}
	req, err := http.NewRequest("POST", fmt.Sprintf("%s/queue", BOP), bytes.NewBuffer(payload))
	if err != nil {
		return addedToQueue{err}
	}
	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return addedToQueue{err}
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return addedToQueue{err: errors.New("server said no.")}
	}

	return addedToQueue{}
}

type refetchedSongs struct {
	songs []Song
	err   error
}

func (m model) fetchSongs() tea.Msg {
	if m.input.Value() == "" {
		return refetchedSongs{
			songs: []Song{},
		}
	}

	maxCount := (m.termH / 3) - 3
	payload := []byte(fmt.Sprintf("{\"query\": \"s:%s\", \"limit\": %d}", m.input.Value(), maxCount))
	req, err := http.NewRequest("POST", fmt.Sprintf("%s/search", BOP), bytes.NewBuffer(payload))
	if err != nil {
		return refetchedSongs{
			err: errors.New("Could not fetch data..."),
		}
	}

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return refetchedSongs{
			err: errors.New("Server error..."),
		}
	}
	defer resp.Body.Close()

	var data []Song
	d := json.NewDecoder(resp.Body)
	err = d.Decode(&data)
	if err != nil {
		return refetchedSongs{
			err: errors.New("Could not parse response..."),
		}
	}

	// parsed := []Song{}
	// for i := 0; i < maxCount; i++ {
	// 	if i > len(data)-1 {
	// 		break
	// 	}
	//
	// 	parsed = append(parsed, data[i])
	// }

	return refetchedSongs{
		songs: data,
	}
}
