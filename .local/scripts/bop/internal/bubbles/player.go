package bubbles

import (
	"bop/internal"
	"fmt"
	"os"
	"path"
	"strings"
	"time"

	"github.com/charmbracelet/bubbles/progress"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/lukesampson/figlet/figletlib"
)

func (m Player) title(msg string, width int) string {
	home, err := os.UserHomeDir()
	if err != nil {
		return msg
	}
	font, err := figletlib.GetFontByName(path.Join(home, ".local", "fonts"), "ansi")
	if err != nil {
		return msg
	}

	t := figletlib.SprintMsg(msg, font, width, font.Settings(), "left")
	// non-ascii characters
	if strings.TrimSpace(t) == "" {
		return fmt.Sprintf("\n%s\n", msg)
	}

	return strings.Trim(t, "\n")
}

type tickMsg time.Time
type songFetchedMsg struct {
	song      Song
	err       error
	cacheFile *os.File
}

func (m Player) fetchSong() tea.Msg {
	song, f, err := m.GetCurrentSong(m.coverWidth())
	if err != nil {
		return songFetchedMsg{err: err}
	}

	return songFetchedMsg{song: song, cacheFile: f}
}

func (m Player) redrawCover() tea.Msg {
	f, err := m.AttachAsciiToSong(&m.song, m.coverWidth())
	if err != nil {
		return songFetchedMsg{err: err}
	}

	return songFetchedMsg{song: m.song, cacheFile: f}
}

func doTick() tea.Cmd {
	return tea.Tick(time.Second*1, func(t time.Time) tea.Msg {
		return tickMsg{}
	})
}

type Player struct {
	CurrentSecond int
	TotalSeconds  int
	song          Song
	bar           progress.Model
	err           error
	termW         int
	termH         int
	cover         string
	loading       bool
	mounted       bool
	cachedImage   *os.File
}

func NewPlayer(current, total int) Player {
	color1 := string(internal.KanagawaDragon.Primary)
	b := progress.New(progress.WithSolidFill(color1), progress.WithoutPercentage())

	return Player{
		CurrentSecond: current,
		TotalSeconds:  total,
		bar:           b,
		loading:       true,
	}
}

func (m Player) Init() tea.Cmd {
	return nil
}

func (m Player) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case songFetchedMsg:
		m.loading = false
		if msg.err != nil {
			m.err = msg.err
			return m, nil
		}
		m.cachedImage = msg.cacheFile
		m.CurrentSecond = msg.song.CurrentSecond
		m.TotalSeconds = msg.song.TotalSeconds
		m.cover = msg.song.Ascii
		m.song = msg.song
		if m.mounted {
			return m, nil
		}
		m.mounted = true
		return m, doTick()

	case tickMsg:
		if m.CurrentSecond >= m.TotalSeconds {
			return m, tea.Batch(m.fetchSong, doTick())
		}
		m.CurrentSecond++
		return m, tea.Batch(doTick())

	case progress.FrameMsg:
		progressModel, cmd := m.bar.Update(msg)
		m.bar = progressModel.(progress.Model)
		return m, cmd

	case tea.WindowSizeMsg:
		m.termW = msg.Width
		m.termH = msg.Height
		m.bar.Width = msg.Width - 12 - m.barWidth() // start+end time and cover size
		if m.mounted {
			return m, m.redrawCover
		}
		return m, m.fetchSong

	case tea.KeyMsg:
		switch msg.String() {
		case "r":
			m.loading = true
			m.err = nil
			return m, m.fetchSong

		case "ctrl+c":
			_ = m.Cleanup()
			return m, tea.Quit
		}
	}

	return m, nil
}

func (m Player) View() string {
	if m.err != nil {
		return internal.CenterInScreen(m.termW, m.termH, internal.CatSaysSerious(m.err.Error()))
	}

	if m.loading {
		return internal.CenterInScreen(m.termW, m.termH, internal.CatSays("Loading..."))
	}

	if m.err != nil {
		return m.err.Error()
	}

	title := lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, m.title(m.song.DisplayName, m.termW-20))
	if m.screenTooBigForTitle(title) {
		title = lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, m.song.DisplayName)
	}

	artist := lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, artistStyle.Render(m.song.Artist))
	banner := lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, m.cover)
	if m.cover == "" {
		cover := m.tempCover()
		banner = lipgloss.PlaceHorizontal(m.termW, lipgloss.Center, cover)
	}

	bar := m.bar.ViewAs(m.calculateNextSecondTick())
	details := lipgloss.JoinHorizontal(lipgloss.Left, timeStyle.Render(toDuration(m.CurrentSecond)), bar, timeStyle.Render(toDuration(m.TotalSeconds-m.CurrentSecond)))

	return lipgloss.Place(m.termW-10, m.termH, lipgloss.Center, lipgloss.Center, lipgloss.JoinVertical(lipgloss.Center, title, artist, banner, details))
}

func (m Player) calculateNextSecondTick() float64 {
	step := (100 / float64(m.TotalSeconds)) * float64(m.CurrentSecond)

	return step / 100
}

func toDuration(seconds int) string {
	minutes := seconds / 60
	seconds = seconds - (minutes * 60)
	return fmt.Sprintf("%02d:%02d", minutes, seconds)
}

func (m Player) screenTooBigForTitle(title string) bool {
	cover := m.song.Ascii
	if cover == "" {
		cover = m.tempCover()
	}
	return lipgloss.Height(cover)+10+lipgloss.Height(title) > m.termH || lipgloss.Width(cover)+20 > m.termW || lipgloss.Width(title) > m.termW
}

func (m Player) coverWidth() int {
	width := m.termW
	if width <= 0 {
		width = 40
	}

	w := width / 3
	if m.termW < 80 {
		w = width / 2
	}

	return w
}

func (m Player) barWidth() int {
	if m.termW < 80 {
		return m.coverWidth()
	}

	return m.coverWidth() * 2
}

func (m Player) tempCover() string {
	w := m.coverWidth()
	line := strings.Repeat("/", w)
	cover := strings.Repeat(fmt.Sprintf("%s\n", line), (w / 2))
	return cover
}
