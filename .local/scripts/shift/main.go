package main

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"unicode/utf8"

	"github.com/charmbracelet/bubbles/key"
	"github.com/charmbracelet/bubbles/table"
	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"golang.org/x/term"
)

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
	table      table.Model
	termWidth  int
	termHeight int
	sessions   []string
	filtered   []string
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
	i.Width = w - 4
	i.Prompt = switchPrompt
	i.PromptStyle = prompt
	i.Cursor.Style = prompt
	i.Cursor.TextStyle = prompt
	i.TextStyle = prompt
	i.PromptStyle = prompt
	i.Cursor.Style = prompt

	// 5 -> 2 from top/bottom margin, 3 for header and the other one ehh idk lol
	// 4 -> margin
	t := table.New(table.WithColumns([]table.Column{{Width: w - 4}}),
		table.WithRows(sessionsToRows(sessions)),
		table.WithFocused(true),
		table.WithHeight(h-6))

	st := table.DefaultStyles()
	st.Header = line
	st.Selected = selectedLine
	t.SetStyles(st)
	t.KeyMap.LineUp = key.NewBinding(func(opt *key.Binding) {
		opt.SetKeys("up", "shift+tab", "ctrl+p")
	})
	t.KeyMap.LineDown = key.NewBinding(func(opt *key.Binding) {
		opt.SetKeys("down", "tab", "ctrl+n")
	})

	return model{
		input:      i,
		table:      t,
		termWidth:  w,
		termHeight: h,
		sessions:   sessions,
		filtered:   []string{},
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

		case "enter":
			if m.mode == switchSession {
				m.selected = m.table.SelectedRow()[0]
			}
			if m.mode == createSession {
				createSessionParams = strings.Replace(m.input.Value(), "n ", "", 1)
			}
			if m.mode == renameSession {
				renameSessionParam = strings.Replace(m.input.Value(), "r ", "", 1)
			}
			selected = m.selected
			selectedMode = m.mode

			return m, tea.Quit

		case "backspace":
			if m.mode == createSession && m.input.Value() == "n " {
				m.mode = switchSession
				m.input.Prompt = switchPrompt
				m.input.Reset()
			}
			if m.mode == renameSession && m.input.Value() == "r " {
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

	var cmds []tea.Cmd
	var cmd tea.Cmd
	m.input, cmd = m.input.Update(msg)
	cmds = append(cmds, cmd)

	m.table, cmd = m.table.Update(msg)
	cmds = append(cmds, cmd)

	m.table.SetRows(sessionsToRows(m.filtered))
	key, ok := msg.(tea.KeyMsg)
	if ok && shouldGoToTop(key.String()) {
		m.table.GotoTop()
	}

	return m, tea.Batch(cmds...)
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
		v.WriteString(inputText)
		v.WriteString(header.Render("  "))
	}
	if m.mode == renameSession {
		inputText = strings.Replace(inputText, "r ", "", 1)
		v.WriteString(inputText)
		v.WriteString(header.Render("  "))
	}
	if m.mode == switchSession {
		v.WriteString(inputText)
	}

	v.WriteRune('\n')
	v.WriteString(header.Render(strings.Repeat(" ", m.termWidth)))
	v.WriteRune('\n')

	if m.mode == switchSession {
		t := line.Render(m.table.View())
		v.WriteString(strings.Join(strings.Split(t, "\n")[1:], "\n"))
		v.WriteRune('\n')
		v.WriteString(line.Width(m.termWidth).Render(""))
		v.WriteRune('\n')
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
