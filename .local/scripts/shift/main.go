package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"unicode/utf8"

	"github.com/charmbracelet/bubbles/key"
	"github.com/charmbracelet/bubbles/table"
	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"golang.org/x/term"
)

type app struct {
	lines        []string
	selectedMode mode
	escaped      bool
	modes        []mode
}

type model struct {
	input      textinput.Model
	table      table.Model
	termWidth  int
	termHeight int
	filtered   []string
	mode       modeType
	app        *app
	autocompleteElements []os.DirEntry
	autocompleteErr error
}

func newModel(app *app) (model, error) {
	var w int
	var h int
	var err error
	// dimensions were passed as args
	if len(os.Args) >= 3 {
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

	activeMode := app.modes[0]

	i := textinput.New()
	i.Focus()
	i.Width = w - 4
	i.Prompt = activeMode.prompt
	i.PromptStyle = prompt
	i.Cursor.Style = prompt
	i.Cursor.TextStyle = prompt
	i.TextStyle = prompt
	i.PromptStyle = prompt
	i.Cursor.Style = prompt

	// 5 -> 2 from top/bottom margin, 3 for header and the other one ehh idk lol
	// 4 -> margin
	t := table.New(table.WithColumns([]table.Column{{Width: w - 4}}),
		table.WithRows(sessionsToRows(app.lines)),
		table.WithFocused(true),
		table.WithHeight(h-4))

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
		filtered:   []string{},
		mode:       activeMode.mType,
		app:        app,
		autocompleteElements: []os.DirEntry{},
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
			m.app.escaped = true
			return m, tea.Quit

		case "esc":
			m.app.escaped = true
			return m, tea.Quit

		case "enter":
			for range m.app.modes {
				m.app.selectedMode = m.app.modes[m.mode]
				// only special case
				if m.mode == switchSession {
					if len(m.table.SelectedRow()) > 0 {
						m.app.selectedMode.params = m.table.SelectedRow()[0]
					}
					continue
				}

				m.app.selectedMode.params = m.app.cleanUpModeParams(m.input.Value())
			}

			return m, tea.Quit

		case "backspace":
			for _, mode := range m.app.modes {
				if m.mode == mode.mType && strings.TrimSpace(m.input.Value()) == mode.prefix {
					mode := m.app.switchMode()
					m.mode = mode.mType
					m.input.Prompt = mode.prompt
					m.input.Reset()
				}
			}

		case " ":
			for _, mode := range m.app.modes {
				if m.input.Value() == mode.prefix {
					m.mode = mode.mType
					m.input.Prompt = mode.prompt
				}
			}

		case "tab":
			if m.mode != createSession {
				break
			}

			m.autocompletePath()
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
	if m.mode == switchSession {
		v.WriteString("\n")
	}

	title := ""
	for _, mode := range m.app.modes {
		if m.mode == mode.mType {
			title = mode.title
		}
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
	if m.mode != switchSession {
		v.WriteString(m.app.cleanUpModeParamsForView(inputText))
		v.WriteString(header.Render("  "))
	} else {
		v.WriteString(inputText)
	}

	v.WriteRune('\n')
	v.WriteString(header.Render(strings.Repeat(" ", m.termWidth)))
	v.WriteRune('\n')

	if m.mode == switchSession {
		t := line.Width(m.termWidth).Render(m.table.View())
		tc := strings.Split(t, "\n")[1:]
		v.WriteString(strings.Join(tc, "\n"))
		v.WriteRune('\n')
		v.WriteString(line.Width(m.termWidth).Render(""))
		v.WriteRune('\n')
	}

	if m.mode == createSession {
		if m.autocompleteErr != nil {
			v.WriteString(m.autocompleteErr.Error())
			v.WriteRune('\n')
		} else {
			for i, elem := range m.autocompleteElements {
				if i >= 5 {
					break
				}

				v.WriteString(line.Width(m.termWidth).Render(elem.Name()))
				v.WriteRune('\n')
			}
		}
	}

	return v.String()
}

func main() {
	app := app{}
	err := app.loadLines()
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
		return
	}
	app.loadModes()

	model, err := newModel(&app)
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

	if app.escaped {
		return
	}

	f, err := os.Create(".__SHIFT__")
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
		return
	}
	defer f.Close()

	text := fmt.Sprintf("%s %s", app.selectedMode.name, app.selectedMode.params)

	_, err = f.WriteString(text)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
		return
	}
}
