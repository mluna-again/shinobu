package main

import (
	"embed"
	"path/filepath"
	"time"

	tea "github.com/charmbracelet/bubbletea"
)

//go:embed ascii/*.ascii
var samuraiFrames embed.FS

const FRAME_TICK_DURATION = time.Second / time.Duration(10)

type frameTickMsg struct{}

func bannerTick() tea.Msg {
	return frameTickMsg{}
}

func ascii() ([]string, error) {
	frames := []string{}
	dir, err := samuraiFrames.ReadDir("ascii")
	if err != nil {
		return []string{}, err
	}

	for _, f := range dir {
		frame, err := samuraiFrames.ReadFile(filepath.Join("ascii", f.Name()))
		if err != nil {
			return []string{}, err
		}

		frames = append(frames, string(frame))
	}

	return frames, nil
}

func nextFrame(frames []string, actual int) (string, int) {
	index := actual + 1
	if index >= len(frames) {
		index = 0
	}

	return frames[index], index
}
