package selector

import "github.com/charmbracelet/lipgloss"

type Theme struct {
	BG        lipgloss.Color
	BGLight   lipgloss.Color
	BGDark    lipgloss.Color
	FG        lipgloss.Color
	FGLight   lipgloss.Color
	Primary   lipgloss.Color
	Secondary lipgloss.Color
}

var kanagawaDragon = Theme{
	BG:        lipgloss.Color("#181616"),
	BGLight:   lipgloss.Color("#393836"),
	BGDark:    lipgloss.Color("#1D1C19"),
	FG:        lipgloss.Color("#c5c9c5"),
	FGLight:   lipgloss.Color("#9e9b93"),
	Primary:   lipgloss.Color("#c4b28a"),
	Secondary: lipgloss.Color("#c4746e"),
}

func loadTheme(t Theme) {
	textS.Background(t.BG)
	textS.Foreground(t.FG)
	placeholderS.Background(t.BG)
	cursorS.Background(t.BG)
	cursorS.Foreground(t.FGLight)
	promptS.Background(t.Primary).Foreground(t.BG)
	// inputS.Background(t.BG)
	songItemSelectedS.Foreground(t.Primary)
	songItemSelectedS.Background(t.BG)
	songSelColSelectedS.Background(t.BG)
	songCellSelectedS.Background(t.BG)
	queueSongComptSelectedS.Background(t.BG)
	songSelColS.Foreground(t.FGLight)
	songSelColSelectedS.Foreground(t.FGLight)
	songCellS.Foreground(t.FGLight)
	songCellSelectedS.Foreground(t.FGLight)
	placeholderS.Foreground(t.FGLight)
	queueSongComptS.Foreground(t.FGLight)
	queueSongComptSelectedS.Foreground(t.FGLight)
	queueHeaderComptS.Foreground(t.FG)
	songItemS.Background(t.BGDark)
	songSelColS.Background(t.BGDark)
	songCellS.Background(t.BGDark)
	songHeaderS.Background(t.BGDark)
	songColS.Background(t.BGDark)
	songViewportS.Background(t.BGDark)
	songViewportHeaderS.Background(t.BGDark)
	helpInfo.Background(t.BGDark)
	helpRInfo.Background(t.BGDark)
	helpLInfo.Background(t.BGDark)
	bannerS.Background(t.BGDark)
	bannerBGS.Background(t.BGDark)
	queueSongComptS.Background(t.BGDark)
	queueHeaderComptS.Background(t.BGDark)
	queueViewportS.Background(t.BGDark)
}
