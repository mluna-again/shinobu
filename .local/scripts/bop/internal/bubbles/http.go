package bubbles

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"time"
)

type Song struct {
	ID            string `json:"id"`
	DisplayName   string `json:"display_name"`
	Artist        string `json:"artist"`
	ImageUrl      string `json:"image_url"`
	CurrentSecond int    `json:"current_second"`
	TotalSeconds  int    `json:"total_seconds"`
	IsPlaying     bool   `json:"is_playing"`
	Album         string `json:"album"`
	Duration      string `json:"duration"`
	Ascii         string
}

var BOP = "http://localhost:8888"

func BopCoverTempFile() (*os.File, error) {
	return os.CreateTemp("", "bop-cover-*")
}

func BasicClient() http.Client {
	client := http.Client{}
	client.Timeout = time.Second * 5

	return client
}

func GetCurrentSong(coversize int) (Song, error) {
	client := BasicClient()
	resp, err := client.Get(fmt.Sprintf("%s/status", BOP))
	if resp.StatusCode == http.StatusNotFound {
		return Song{}, errors.New("no music playing")
	}

	if err != nil {
		return Song{}, err
	}
	defer resp.Body.Close()

	var data Song
	d := json.NewDecoder(resp.Body)
	err = d.Decode(&data)
	if err != nil {
		return Song{}, err
	}

	err = AttachAsciiToSong(&data, coversize)
	if err != nil {
		return Song{}, err
	}

	return data, nil
}

func AttachAsciiToSong(s *Song, size int) error {
	client := BasicClient()
	resp, err := client.Get(s.ImageUrl)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	file, err := BopCoverTempFile()
	if err != nil {
		return err
	}
	defer func() {
		err := file.Close()
		if err != nil {
			return
		}
		_ = os.Remove(file.Name())
	}()
	_, err = io.Copy(file, resp.Body)
	if err != nil {
		return err
	}

	output, err := exec.Command("chafa", "-s", fmt.Sprintf("%dx%d", size, size), file.Name()).Output()
	if err != nil {
		return err
	}

	s.Ascii = string(output)

	return nil
}
