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

const maxSessionsAtATime = 5

var createSessionParams string
var renameSessionParam string
var selectedMode mode
var selected string
var escaped bool

var switchPrompt = "  "
var createPrompt = "  "
var renamePrompt = " 󰔤 "

var switchTitle = " Switch session "
var createTitle = " New session "
var renameTitle = " Rename session "

type mode int

const (
	switchSession mode = iota
	createSession
	renameSession
)

type model struct {
	input      textinput.Model
	termWidth  int
	termHeight int
	sessions   []string
	filtered   []string
	cursor     int
	selected   string
	mode       mode
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
	i.Width = w
	i.Prompt = switchPrompt
	i.PromptStyle = prompt
	i.Cursor.Style = prompt
	i.Cursor.TextStyle = prompt
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
		mode:       switchSession,
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

		case "tab", "down", "ctrl+n":
			if m.cursor == maxSessionsAtATime-1 {
				m.cursor = 0
			} else {
				m.cursor++
			}

		case "shift+tab", "up", "ctrl+p":
			if m.cursor == 0 {
				m.cursor = maxSessionsAtATime - 1
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
			selectedMode = m.mode
			if m.mode == createSession {
				createSessionParams = strings.Replace(m.input.Value(), "n ", "", 1)
			}
			if m.mode == renameSession {
				renameSessionParam = strings.Replace(m.input.Value(), "r ", "", 1)
			}

			return m, tea.Quit

		case "backspace":
			if m.mode == createSession && m.input.Value() == "n " {
				m.mode = switchSession
				m.input.Prompt = switchPrompt
				m.input.Reset()
			}

		case " ":
			if m.input.Value() == "n" {
				m.mode = createSession
				m.input.Prompt = createPrompt
			}

			if m.input.Value() == "r" {
				m.mode = renameSession
				m.input.Prompt = renamePrompt
			}
		}
	}
	m.fuzzyFind()

	var cmd tea.Cmd
	m.input, cmd = m.input.Update(msg)

	return m, cmd
}

func (m model) View() string {
	v := strings.Builder{}

	title := switchTitle
	if m.mode == createSession {
		title = createTitle
	}
	if m.mode == renameSession {
		title = renameTitle
	}

	titleLen := utf8.RuneCount([]byte(title))
	padding := m.termWidth - titleLen

	hLeft := header.
		Render(strings.Repeat(" ", padding/2))

	hCenter := headerTitle.
		Width(titleLen).
		Render(title)

	hRight := header.
		Render(strings.Repeat(" ", m.termWidth-titleLen-(padding/2)))

	v.WriteString(hLeft)
	v.WriteString(hCenter)
	v.WriteString(hRight)
	v.WriteRune('\n')

	inputText := m.input.View()
	if m.mode == createSession {
		inputText = strings.Replace(inputText, "n ", "", 1)
	}
	if m.mode == renameSession {
		inputText = strings.Replace(inputText, "r ", "", 1)
	}

	v.WriteString(inputText)
	v.WriteRune('\n')
	v.WriteString(header.Render(strings.Repeat(" ", m.termWidth)))
	v.WriteRune('\n')

	if m.mode == switchSession {
		if len(m.filtered) > 0 {
			v.WriteString(line.Width(m.termWidth).Render(""))
			v.WriteRune('\n')
		}

		first := []string{}
		for i := 0; i < len(m.filtered); i++ {
			if len(first) >= maxSessionsAtATime {
				break
			}
			first = append(first, m.filtered[i])
		}
		for i, session := range first {
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
	}

	vertMargin := 5

	remainingSpace := m.termHeight - len(m.sessions) - vertMargin
	if len(m.filtered) > 0 {
		remainingSpace = m.termHeight - len(m.filtered) - vertMargin
	}
	if len(m.filtered) >= maxSessionsAtATime {
		remainingSpace = m.termHeight - maxSessionsAtATime - vertMargin
	}
	if len(m.filtered) == 0 {
		remainingSpace = 0
	}

	if m.mode != switchSession {
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

	text := fmt.Sprintf("%s %s", "switch", selected)
	if selectedMode == createSession {
		params := strings.Split(createSessionParams, " ")
		if len(params) == 1 {
			text = fmt.Sprintf("%s %s", "create", params[0])
		}
		if len(params) == 2 {
			text = fmt.Sprintf("%s %s %s", "create", params[0], params[1])
		}
	}

	if selectedMode == renameSession {
		text = fmt.Sprintf("%s %s", "rename", renameSessionParam)
	}

	_, err = f.WriteString(text)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
		return
	}
}
