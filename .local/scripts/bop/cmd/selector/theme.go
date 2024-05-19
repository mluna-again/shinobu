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
	BGLight:   lipgloss.Color("#181616"),
	BG:        lipgloss.Color("#1D1C19"),
	BGDark:    lipgloss.Color("#12120f"),
	FG:        lipgloss.Color("#c5c9c5"),
	FGLight:   lipgloss.Color("#9e9b93"),
	Primary:   lipgloss.Color("#c4b28a"),
	Secondary: lipgloss.Color("#c4746e"),
}

func loadTheme(t Theme) {
	textS = textS.Background(t.BGLight)
	textS = textS.Foreground(t.FG)
	placeholderS = placeholderS.Background(t.BGLight)
	placeholderS = placeholderS.Foreground(t.FGLight)
	cursorS = cursorS.Background(t.BGLight)
	cursorS = cursorS.Foreground(t.FGLight)
	promptS = promptS.Background(t.Primary).Foreground(t.BG)
	inputS = inputS.Background(t.BGLight)
	songItemSelectedS = songItemSelectedS.Foreground(t.Primary)
	songItemSelectedS = songItemSelectedS.Background(t.BG)
	songSelColSelectedS = songSelColSelectedS.Background(t.BG)
	songCellSelectedS = songCellSelectedS.Background(t.BG)
	queueSongComptSelectedS = queueSongComptSelectedS.Background(t.BG)
	songSelColS = songSelColS.Foreground(t.FGLight)
	songSelColSelectedS = songSelColSelectedS.Foreground(t.FGLight)
	songCellS = songCellS.Foreground(t.FGLight)
	songCellSelectedS = songCellSelectedS.Foreground(t.FGLight)
	queueSongComptS = queueSongComptS.Foreground(t.FGLight)
	queueSongComptSelectedS = queueSongComptSelectedS.Foreground(t.FGLight)
	queueHeaderComptS = queueHeaderComptS.Foreground(t.FG)
	songItemS = songItemS.Background(t.BGDark)
	songSelColS = songSelColS.Background(t.BGDark)
	songCellS = songCellS.Background(t.BGDark)
	songHeaderS = songHeaderS.Background(t.BGDark)
	songColS = songColS.Background(t.BGDark)
	songViewportS = songViewportS.Background(t.BGDark)
	songViewportHeaderS = songViewportHeaderS.Background(t.BGDark)
	helpInfo = helpInfo.Background(t.BGDark)
	helpRInfo = helpRInfo.Background(t.BGDark)
	helpLInfo = helpLInfo.Background(t.BGDark)
	bannerS = bannerS.Background(t.BGDark)
	bannerBGS = bannerBGS.Background(t.BGDark)
	queueSongComptS = queueSongComptS.Background(t.BGDark)
	queueHeaderComptS = queueHeaderComptS.Background(t.BGDark)
	queueViewportS = queueViewportS.Background(t.BGDark)
}
