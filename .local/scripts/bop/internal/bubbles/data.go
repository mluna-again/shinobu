package bubbles

import (
	"bop/internal"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
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

var BOP = fmt.Sprintf("http://%s:%s", os.Getenv("BOP_HOST"), os.Getenv("PORT"))

func BopCoverTempFile() (*os.File, error) {
	return os.CreateTemp("", "bop-cover-*")
}

func BasicClient() http.Client {
	client := http.Client{}
	client.Timeout = time.Second * 5

	return client
}

func (m *Player) GetCurrentSong(coversize int) (Song, *os.File, error) {
	m.removeCache()
	client := BasicClient()
	resp, err := client.Get(fmt.Sprintf("%s/status", BOP))
	if err != nil {
		return Song{}, nil, err
	}
	if resp.StatusCode == http.StatusNotFound {
		return Song{}, nil, errors.New("no music playing")
	}

	defer resp.Body.Close()

	var data Song
	d := json.NewDecoder(resp.Body)
	err = d.Decode(&data)
	if err != nil {
		return Song{}, nil, err
	}

	f, err := m.AttachAsciiToSong(&data, coversize)
	if err != nil {
		return Song{}, nil, err
	}

	return data, f, nil
}

func (m Player) AttachAsciiToSong(s *Song, size int) (*os.File, error) {
	if s.ImageUrl == "" {
		return nil, nil
	}

	file, err := m.getImagePath(s.ImageUrl)
	if err != nil {
		return nil, err
	}
	output, err := internal.GetChafaCmd(file.Name(), size).Output()
	if err != nil {
		return nil, err
	}

	s.Ascii = string(output)

	return file, nil
}

func (m *Player) getImagePath(imageUrl string) (*os.File, error) {
	if m.cachedImage != nil {
		return m.cachedImage, nil
	}

	client := BasicClient()
	resp, err := client.Get(imageUrl)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	file, err := BopCoverTempFile()
	if err != nil {
		return nil, err
	}
	_, err = io.Copy(file, resp.Body)
	if err != nil {
		return nil, err
	}

	return file, nil
}

func (m *Player) Cleanup() error {
	if m.cachedImage != nil {
		err := m.cachedImage.Close()
		if err != nil {
			return err
		}
		err = os.Remove(m.cachedImage.Name())
		if err != nil {
			return err
		}

		m.cachedImage = nil
	}

	return nil
}

func (m *Player) removeCache() {
	if m.cachedImage == nil {
		return
	}
	m.cachedImage = nil

	err := m.cachedImage.Close()
	if err != nil {
		return
	}

	_ = os.Remove(m.cachedImage.Name())
}
