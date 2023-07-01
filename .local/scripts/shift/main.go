package main

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"unicode/utf8"

	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"golang.org/x/term"
)

var selected string
var escaped bool

type model struct {
	input      textinput.Model
	termWidth  int
	termHeight int
	sessions   []string
	filtered   []string
	cursor     int
	selected   string
}

func newModel() (model, error) {
	var w int
	var h int
	var err error
	// dimensions were passed as args
	if len(os.Args) == 3 {
		w, err = strconv.Atoi(os.Args[1])
		if err == nil {
			h, err = strconv.Atoi(os.Args[2])
		}
	} else {
		w, h, err = term.GetSize(int(os.Stdin.Fd()))
	}
	if err != nil {
		return model{}, err
	}

	out, err := exec.Command("tmux", "list-sessions").Output()
	if err != nil {
		return model{}, err
	}

	s := strings.Split(string(out), "\n")
	sessions, err := splitSessions(s[:len(s)-1])
	if err != nil {
		return model{}, err
	}

	i := textinput.New()
	i.Focus()
	i.Width = w - 2 // padding
	i.Prompt = " "
	i.TextStyle = prompt
	i.PromptStyle = prompt
	i.Cursor.Style = prompt

	return model{
		input:      i,
		termWidth:  w,
		termHeight: h,
		sessions:   sessions,
		filtered:   []string{},
		cursor:     0,
	}, nil
}

func (m model) Init() tea.Cmd {
	return textinput.Blink
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c":
			escaped = true
			return m, tea.Quit

		case "esc":
			escaped = true
			return m, tea.Quit

		case "tab":
			if m.cursor == len(m.filtered)-1 {
				m.cursor = 0
			} else {
				m.cursor++
			}

		case "shift+tab":
			if m.cursor == 0 {
				m.cursor = len(m.filtered) - 1
			} else {
				m.cursor--
			}

		case "enter":
			if len(m.filtered) > 0 {
				m.selected = m.filtered[m.cursor]
			} else {
				if len(m.sessions) > 0 {
					m.selected = m.sessions[0]
				}
			}

			selected = m.selected
			return m, tea.Quit
		}
	}
	m.fuzzyFind()

	var cmd tea.Cmd
	m.input, cmd = m.input.Update(msg)

	return m, cmd
}

func (m model) View() string {
	v := strings.Builder{}

	title := " Switch session "
	titleLen := utf8.RuneCount([]byte(title))
	padding := m.termWidth - titleLen

	hLeft := header.
		Render(strings.Repeat(" ", padding/2))

	hCenter := headerTitle.
		Width(titleLen).
		Render(title)

	hRight := header.
		Render(strings.Repeat(" ", padding/2))

	v.WriteString(hLeft)
	v.WriteString(hCenter)
	v.WriteString(hRight)
	v.WriteRune('\n')

	v.WriteRune(' ')
	v.WriteString(m.input.View())
	v.WriteRune(' ')
	v.WriteRune('\n')
	v.WriteString(header.Render(strings.Repeat(" ", m.termWidth)))
	v.WriteRune('\n')

	if len(m.filtered) > 0 {
		v.WriteString(line.Width(m.termWidth).Render(""))
		v.WriteRune('\n')
	}
	for i, session := range m.filtered {
		v.WriteString(line.Width(2).Render("  "))

		if i == m.cursor {
			v.WriteString(selectedLine.Width(m.termWidth - 4).Render(session))
		} else {
			v.WriteString(line.Width(m.termWidth - 4).Render(session))
		}

		v.WriteString(line.Width(2).Render("  "))
		v.WriteRune('\n')
	}
	if len(m.filtered) > 0 {
		v.WriteString(line.Width(m.termWidth).Render(""))
	}
	v.WriteRune('\n')

	remainingSpace := m.termHeight - len(m.sessions) - 5
	if len(m.filtered) > 0 {
		remainingSpace = m.termHeight - len(m.filtered) - 5
	}
	if len(m.filtered) == 0 {
		remainingSpace = 0
	}

	for i := 0; i < remainingSpace; i++ {
		v.WriteString(line.Width(m.termWidth).Render(""))
		if i != remainingSpace-1 {
			v.WriteRune('\n')
		}
	}

	return v.String()
}

func main() {
	model, err := newModel()
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
		return
	}

	p := tea.NewProgram(model)
	if _, err := p.Run(); err != nil {
		fmt.Printf("Error! %s", err.Error())
		os.Exit(1)
		return
	}

	if escaped {
		return
	}

	f, err := os.Create(".__SHIFT__")
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
		return
	}
	defer f.Close()
	_, err = f.WriteString(selected)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
		return
	}
}
