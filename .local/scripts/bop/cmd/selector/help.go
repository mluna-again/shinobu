package selector

import (
	"bop/internal"
	"strings"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

var helpBanner = `
          Press ? or Esc to go back

        ████                      ████
      ██░░░░██                  ██░░░░██
      ██░░░░██                  ██░░░░██
    ██░░░░░░░░██████████████████░░░░░░░░██
    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██
    ██░░░░░░░░▓▓▓▓░░▓▓▓▓▓▓░░▓▓▓▓░░░░░░░░██
  ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
  ██░░██░░░░████░░░░░░░░░░░░░░████░░░░██░░██
  ██░░░░██░░████░░░░░░██░░░░░░████░░██░░░░██
██░░░░██░░░░░░░░░░░░██████░░░░░░░░░░░░██░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██
██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
██▓▓▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓██
██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██ `

type helpModel struct {
	termW int
	termH int
}

func newHelp() helpModel {
	return helpModel{}
}

func (m helpModel) Init() tea.Cmd {
	return nil
}

func (m helpModel) Update(msg tea.Msg) (helpModel, tea.Cmd) {
	return m, nil
}

func (m helpModel) View() string {
	s := strings.Builder{}
	s.WriteString("\n\n")
	s.WriteString("Queue: press q outside of the search input to open the queue.\n")
	s.WriteString("Search: press s inside the queue to go back to the search screen.\n")
	s.WriteString("\n\nSearching:\n")
	s.WriteString("You can use the following prefixes: from, by\n")
	s.WriteString("For example, 'from:yeezus' will fetch all songs from the Yeezus album.\n")
	s.WriteString("Whereas 'from:ye violent crimes' will fetch Violent Crimes from the Ye album.\n\n")
	s.WriteString("Tags:\n")
	s.WriteString("You can use the following tags in your search: @latest\n")
	s.WriteString("The query 'from:\"frank ocean\" @latest' will fetch your latest liked songs by Frank Ocean.\n")


	help := lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, s.String())
	help = lipgloss.PlaceVertical(m.termH-lipgloss.Height(helpBanner), lipgloss.Top, help)

	return lipgloss.JoinVertical(lipgloss.Bottom, help, internal.CenterBanner(m.termW, helpBanner))
}
