package main

import (
	"flag"
	"fmt"
	"os"
	"strings"
	"unicode/utf8"

	"github.com/charmbracelet/bubbles/key"
	"github.com/charmbracelet/bubbles/table"
	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/muesli/termenv"
)

type app struct {
	lines             []string
	selectedMode      mode
	escaped           bool
	modes             []mode
	startingModeTitle string
	startingModeIcon  string
	finalQuery        string
	startingMode      string
	themeName         string
	theme             Styles
	historyID         string
	history           []string
	historyIndex      int
}

type model struct {
	input                        textinput.Model
	table                        table.Model
	termWidth                    int
	termHeight                   int
	filtered                     []string
	mode                         modeType
	app                          *app
	autocompleteElements         []os.DirEntry
	autocompleteErr              error
	autocompleting               bool
	backspacePressedOnEmptyQuery bool
}

func newModel(app *app, w int, h int) (model, error) {
	activeMode := app.modes[0]
	for _, mode := range app.modes {
		if mode.name == app.startingMode {
			activeMode = mode
		}
	}

	i := textinput.New()
	i.Focus()
	i.Width = w - 4
	i.Prompt = activeMode.prompt
	i.PromptStyle = app.theme.prompt
	i.Cursor.Style = app.theme.prompt
	i.Cursor.TextStyle = app.theme.prompt
	i.TextStyle = app.theme.prompt
	i.PromptStyle = app.theme.prompt
	i.Cursor.Style = app.theme.prompt

	// 5 -> 2 from top/bottom margin, 3 for header and the other one ehh idk lol
	// 4 -> margin
	t := table.New(table.WithColumns([]table.Column{{Width: w - 4}}),
		table.WithRows(sessionsToRows(app.lines)),
		table.WithFocused(true),
		table.WithHeight(h-4))

	st := table.DefaultStyles()
	st.Header = app.theme.line
	st.Selected = app.theme.selectedLine
	t.SetStyles(st)
	t.KeyMap.LineUp = key.NewBinding(func(opt *key.Binding) {
		opt.SetKeys("up", "shift+tab", "ctrl+p")
	})
	t.KeyMap.LineDown = key.NewBinding(func(opt *key.Binding) {
		opt.SetKeys("down", "tab", "ctrl+n")
	})

	return model{
		input:                i,
		table:                t,
		termWidth:            w,
		termHeight:           h,
		filtered:             []string{},
		mode:                 activeMode.mType,
		app:                  app,
		autocompleteElements: []os.DirEntry{},
	}, nil
}

func (m model) Init() tea.Cmd {
	return textinput.Blink
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	m.input.Width = m.inputWidth()

	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c", "ctrl+g":
			m.app.escaped = true
			return m, tea.Quit

		case "esc":
			m.app.escaped = true
			return m, tea.Quit

		case "enter":
			m.app.finalQuery = m.input.Value()
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
			m.app.history = append(m.app.history, m.app.finalQuery)
			m.app.saveHistory()

			return m, tea.Quit

		case "backspace":
			if m.backspacePressedOnEmptyQuery && m.input.Value() == "" {
				return m, tea.Quit
			}
			if m.input.Value() == "" {
				m.backspacePressedOnEmptyQuery = true
			} else {
				m.backspacePressedOnEmptyQuery = false
			}
			m.autocompleting = false
			for _, mode := range m.app.modes {
				if m.mode == mode.mType && strings.TrimSpace(m.input.Value()) == mode.prefix {
					mode := m.app.switchMode()
					m.mode = mode.mType
					m.input.Prompt = mode.prompt
					m.input.Width = m.inputWidth()
					m.input.Reset()
				}
			}

		case " ":
			for _, mode := range m.app.modes {
				current := m.input.Value()
				if len(current) > 1 {
					break
				}

				if current == mode.prefix {
					m.mode = mode.mType
					m.input.Prompt = mode.prompt
				}
			}

		case "tab":
			if m.mode != createSession {
				break
			}

			m.autocompletePath()

		case "/":
			m.autocompleting = false

		case "ctrl+k":
			if len(m.app.history) > m.app.historyIndex {
				val := m.app.history[m.app.historyIndex]
				m.input.SetValue(val)
				m.input.SetCursor(utf8.RuneCount([]byte(val)))
				m.app.historyIndex++
			}

		case "ctrl+j":
			if m.app.historyIndex > 1 {
				val := m.app.history[m.app.historyIndex-2]
				m.input.SetValue(val)
				m.input.SetCursor(utf8.RuneCount([]byte(val)))
				m.app.historyIndex--
			} else if m.app.historyIndex == 1 {
				val := m.app.history[0]
				m.input.SetValue(val)
				m.input.SetCursor(utf8.RuneCount([]byte(val)))
				m.app.historyIndex = 0
			}
			if m.app.historyIndex == 0 {
				m.input.Reset()
			}

		case "ctrl+p":
			index := m.table.Cursor()
			if index == 0 {
				m.table.GotoBottom()
				return m, nil
			}

		case "ctrl+n":
			index := m.table.Cursor()
			if index == len(m.table.Rows())-1 {
				m.table.GotoTop()
				return m, nil
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

	hLeft := m.app.theme.header.
		Render(strings.Repeat(" ", padding/2))

	hCenter := m.app.theme.headerTitle.
		Width(titleLen).
		Render(title)

	hRight := m.app.theme.header.
		Render(strings.Repeat(" ", m.termWidth-titleLen-(padding/2)))

	v.WriteString(hLeft)
	v.WriteString(hCenter)
	v.WriteString(hRight)
	v.WriteRune('\n')

	inputText := m.app.theme.header.Render(m.input.View())
	if m.mode != switchSession {
		query := m.input.Value()
		v.WriteString(m.app.cleanUpModeParamsForView(inputText, query))
		v.WriteString(m.app.theme.header.Render("  "))
	} else {
		counter := m.counterText()
		v.WriteString(m.app.theme.header.Width(m.termWidth - len(counter) - len(inputText)).Render(inputText))
		v.WriteString(m.app.theme.header.Render(counter))
	}

	v.WriteRune('\n')
	v.WriteString(m.app.theme.header.Render(strings.Repeat(" ", m.termWidth)))
	v.WriteRune('\n')

	if m.mode == switchSession {
		t := m.app.theme.line.Width(m.termWidth).Render(m.table.View())
		tc := strings.Split(t, "\n")[1:]
		v.WriteString(strings.Join(tc, "\n"))
		v.WriteRune('\n')
		v.WriteString(m.app.theme.line.Width(m.termWidth).Render(""))
		v.WriteRune('\n')
	}

	if m.mode == createSession {
		if m.autocompleteErr != nil {
			v.WriteString(m.autocompleteErr.Error())
			v.WriteRune('\n')
		}
		if m.autocompleting && len(m.autocompleteElements) > 0 {
			v.WriteString(m.app.theme.line.Width(m.termWidth).Render(""))
			v.WriteRune('\n')
			for i, elem := range m.autocompleteElements {
				if i >= 5 {
					break
				}

				v.WriteString(m.app.theme.line.Width(m.termWidth).Render(elem.Name()))
				v.WriteRune('\n')
			}

			if len(m.autocompleteElements) > 0 && len(m.autocompleteElements) < 5 {
				for i := len(m.autocompleteElements); i < 5; i++ {
					v.WriteString(m.app.theme.line.Width(m.termWidth).Render(""))
					v.WriteRune('\n')
				}
			}
			v.WriteString(m.app.theme.line.Width(m.termWidth).Render(""))
			v.WriteRune('\n')
		}
	}

	return v.String()
}

var switchModeTitle string
var switchModeIcon string
var width int
var height int
var input string
var outputFile string
var startingMode string
var startingInput string
var theme string
var historyID string

func main() {
	flag.StringVar(&switchModeTitle, "title", " Switch session ", "Default mode title")
	flag.StringVar(&switchModeIcon, "icon", "  ", "Default mode title")
	flag.StringVar(&input, "input", "", "Options, by default reads them from stdin")
	flag.StringVar(&outputFile, "output", "", "Output file")
	flag.StringVar(&startingMode, "mode", "switch", "Starting mode, defaults to switch")
	flag.StringVar(&startingInput, "initial", "", "Initial input")
	flag.StringVar(&theme, "theme", "", "Shift's theme, default to the value of ~/.config/shift/theme or 'kanagawa-dragon' if no config file")
	flag.StringVar(&historyID, "history", "", "History ID")
	flag.IntVar(&width, "width", 100, "Menu width")
	flag.IntVar(&height, "height", 10, "Menu height")
	flag.Parse()

	app := app{}
	app.startingModeTitle = switchModeTitle
	app.startingModeIcon = switchModeIcon
	app.startingMode = startingMode

	app.loadTheme(theme)
	app.parseHistory(historyID)

	err := app.loadLines(input)
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
		return
	}
	app.loadModes()

	model, err := newModel(&app, width, height)
	if startingInput != "" {
		model.input.SetValue(startingInput)
	}

	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
		return
	}

	lipgloss.SetColorProfile(termenv.TrueColor)
	p := tea.NewProgram(model, tea.WithAltScreen(), tea.WithOutput(os.Stderr))
	if _, err := p.Run(); err != nil {
		fmt.Fprint(os.Stderr, err.Error())
		os.Exit(1)
		return
	}

	if app.escaped {
		return
	}

	text := fmt.Sprintf("%s %s", app.selectedMode.name, app.selectedMode.params)

	if outputFile != "" {
		f, err := os.Create(outputFile)
		if err != nil {
			fmt.Fprintln(os.Stderr, err.Error())
			os.Exit(1)
			return
		}
		defer f.Close()

		_, err = f.WriteString(app.finalQuery + "\n" + app.selectedMode.params)
		if err != nil {
			fmt.Fprintln(os.Stderr, err.Error())
			os.Exit(1)
			return
		}

		return
	}
	fmt.Println(text)
}
