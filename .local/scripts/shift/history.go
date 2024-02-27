package main

import (
	"errors"
	"io"
	"log"
	"os"
	"path"
	"slices"
	"strings"
)

const MAX_HISTORY_SIZE = 50
var HISTORY_DIR = path.Join(os.Getenv("HOME"), ".cache", "shift_history")

func maybeCreateHistoryDir() {
	_, err := os.Stat(HISTORY_DIR)
	if err != nil && !errors.Is(err, os.ErrNotExist) {
		log.Fatal(err)
	}

	if err == nil {
		return
	}

	err = os.Mkdir(HISTORY_DIR, 0777)
	if err != nil {
		log.Fatal(err)
	}
}

func createHistoryFile(id string) {
	if id == "" {
		return
	}
	p := path.Join(HISTORY_DIR, id)
	f, err := os.Create(p)
	if err != nil {
		log.Fatal(err)
	}

	f.Close()
}

func (a *app) parseHistory(id string) {
	a.historyID = id
	if id == "" {
		return
	}

	maybeCreateHistoryDir()

	p := path.Join(HISTORY_DIR, id)
	f, err := os.Open(p)
	if err != nil && !errors.Is(err, os.ErrNotExist) {
		log.Fatal(err)
	}
	if errors.Is(err, os.ErrNotExist) {
		createHistoryFile(id)
		return
	}
	defer f.Close()

	content, err := io.ReadAll(f)
	if err != nil {
		log.Fatal(err)
	}

	cmds := strings.Split(string(content), "\n")
	filtered := []string{}
	for _, c := range cmds {
		if c == "" {
			continue
		}

		filtered = append(filtered, c)
	}

	a.history = filtered
}

func (a *app) saveHistory() {
	if a.historyID == "" {
		return
	}
	p := path.Join(HISTORY_DIR, a.historyID)

	history := a.history
	if len(history) > MAX_HISTORY_SIZE {
		history = history[0:MAX_HISTORY_SIZE]
	}
	slices.Reverse(history)
	history = removeDuplicateStr(history)

	filtered := []string{}
	for _, h := range history {
		if h == "" {
			continue
		}
		filtered = append(filtered, h)
	}

	output := strings.Join(filtered, "\n")
	err := os.WriteFile(p, []byte(output), os.FileMode(0777))
	if err != nil {
		log.Fatal(err)
	}
}
