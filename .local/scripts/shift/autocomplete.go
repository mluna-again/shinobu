package main

import (
	"fmt"
	"os"
	"strings"
)

func (m *model) autocompletePath() {
	m.autocompleteErr = nil

	var err error
	var path string

	value := strings.Split(m.input.Value(), " ")
	if len(value) != 3 {
		return
	}

	query := value[2]
	if strings.HasPrefix(query, "~") {
		path, err = expandHomeDir(query)
	} else {
		path = query
	}
	if err != nil {
		m.autocompleteErr = err
		return
	}

	queryElems := strings.Split(query, string(os.PathSeparator))
	queryLastElem := ""
	if len(queryElems) > 0 {
		queryLastElem = queryElems[len(queryElems)-1]
	}

	pathWithoutLastElem, isDir := getPathDir(path)
	entries, err := os.ReadDir(pathWithoutLastElem)
	if err != nil {
		m.autocompleteErr = err
		return
	}

	if !isDir {
		matches := []os.DirEntry{}
		for _, entry := range entries {
			if strings.HasPrefix(entry.Name(), queryLastElem) {
				matches = append(matches, entry)
			}
		}
		if len(matches) == 1 {
			m.appendAutocomplete(matches[0].Name())
			return
		}
		m.autocompleteElements = matches
		m.autocompleting = true
		return
	}

	matches := []os.DirEntry{}
	matches = append(matches, entries...)

	if len(matches) == 1 {
		m.appendAutocomplete(matches[0].Name())
		return
	}
	m.autocompleteElements = matches
	m.autocompleting = true
}

func expandHomeDir(p string) (string, error) {
	// if you use windows tough luck buddy
	if !strings.Contains(p, "~") {
		return p, nil
	}

	home, err := os.UserHomeDir()
	return strings.Replace(p, "~", home, 1), err
}

func getPathDir(p string) (string, bool) {
	comps := strings.Split(p, string(os.PathSeparator))
	if !strings.HasSuffix(p, string(os.PathSeparator)) {
		comps = comps[:len(comps)-1]
		newPath := strings.Join(comps, string(os.PathSeparator))
		if newPath == "" {
			return string(os.PathSeparator), false
		}

		return newPath, false
	}

	newPath := strings.Join(comps, string(os.PathSeparator))
	if newPath == "" {
		return string(os.PathSeparator), true
	}

	return strings.Join(comps, string(os.PathSeparator)), true
}

func (m *model) appendAutocomplete(match string) {
	// i validate that value has at least 3 elements in autocompletePath function
	sessionName := strings.Split(m.input.Value(), " ")[1]
	currentValue := strings.Split(m.input.Value(), " ")[2]
	comps := strings.Split(currentValue, string(os.PathSeparator))
	if len(comps) == 0 {
		return
	}
	lastElem := comps[len(comps)-1]

	original, _ := strings.CutSuffix(currentValue, lastElem)
	original, _ = strings.CutSuffix(original, string(os.PathSeparator))
	newComps := []string{original, match}
	newValue := strings.Join(newComps, string(os.PathSeparator))
	newValue = fmt.Sprintf("c %s %s", sessionName, newValue)
	m.input.SetValue(newValue)
	m.input.SetCursor(len(newValue))
	m.autocompleting = false
}
