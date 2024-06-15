return {
	s("die", {
		t({ "os.Exit(1)", "return" }),
		i(1),
	}),

	s("edie", {
		t({
			"if err != nil {",
			"\tfmt.Println(err.Error())",
			"\tos.Exit(1)",
			"\treturn",
			"}",
		}),
		i(1),
	}),

	s("iferr", {
		t({
			"if err != nil {",
			"\treturn",
		}),
		i(1),
		t({
			"",
			"}",
		}),
	}),

	s("main", {
		t({
			"package main",
			"",
			"func main() {",
			"\t",
		}),
		i(1),
		t({
			"",
			"}",
		}),
	}),

	s("handler", {
		t("func "),
		i(1),
		t({
			"Handler(w http.ResponseWriter, r *http.Request) {",
			"\t",
		}),
		i(2),
		t({
			"",
			"}",
		}),
	}),

	s("logerr", {
		t('fmt.Fprintf(os.Stderr, "'),
		i(1),
		t({
			': \\n%v", err)',
		}),
	}),

	s("tea", {
		t({
		[[package main]],
		[[]],
		[[import (]],
		[[	"fmt"]],
		[[	"os"]],
		[[]],
		[[	"github.com/charmbracelet/lipgloss"]],
		[[	tea "github.com/charmbracelet/bubbletea"]],
		[[	zone "github.com/lrstanley/bubblezone"]],
		[[)]],
		[[]],
		[[type Model struct {}]],
		[[]],
		[[func NewModel() Model {]],
		[[	return Model{}]],
		[[}]],
		[[]],
		[[func (m Model) Init() tea.Cmd {]],
		[[	return nil]],
		[[}]],
		[[]],
		[[func (m Model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {]],
		[[	switch msg := msg.(type) {]],
		[[	case tea.KeyMsg:]],
		[[			switch msg.String() {]],
		[[			case "ctrl+c", "q":]],
		[[					return m, tea.Quit]],
		[[			}]],
		[[	}]],
		[[]],
		[[	return m, nil]],
		[[}]],
		[[]],
		[[func (m Model) View() string {]],
		[[	return ":D"]],
		[[}]],
		[[]],
		[[func main() {]],
		[[	p := tea.NewProgram(NewModel())]],
		[[	if _, err := p.Run(); err != nil {]],
		[[			fmt.Fprintf(os.Stderr, "Upss: %v", err)]],
		[[			os.Exit(1)]],
		[[	}]],
		[[}]],
		})
	}),

	s("prettydate", {
		t({
			"t := time.Now()",
			't.Format("Monday 02, January 2006 at 03:04 pm")',
		})
	})
}, {}
