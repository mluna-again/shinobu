package server

import (
	"strings"

	"github.com/zmb3/spotify/v2"
)

func songBy(s spotify.SimpleTrack, artist string) bool {
	for _, a := range s.Artists {
		if strings.Contains(strings.ToLower(a.Name), strings.ToLower(artist)) {
			return true
		}
	}

	return false
}

func fSongBy(s spotify.FullTrack, artist string) bool {
	for _, a := range s.Artists {
		if strings.Contains(strings.ToLower(a.Name), strings.ToLower(artist)) {
			return true
		}
	}

	return false
}

func sSongBy(s spotify.SavedTrack, artist string) bool {
	for _, a := range s.Artists {
		if strings.Contains(strings.ToLower(a.Name), strings.ToLower(artist)) {
			return true
		}
	}

	return false
}

func songFrom(s spotify.SimpleTrack, album string) bool {
	return strings.Contains(strings.ToLower(s.Album.Name), strings.ToLower(album))
}

func fSongFrom(s spotify.FullTrack, album string) bool {
	return strings.Contains(strings.ToLower(s.Album.Name), strings.ToLower(album))
}

func sSongFrom(s spotify.SavedTrack, album string) bool {
	return strings.Contains(strings.ToLower(s.Album.Name), strings.ToLower(album))
}

func songQueried(s spotify.SimpleTrack, query string) bool {
	return strings.Contains(strings.ToLower(s.Name), strings.ToLower(strings.TrimSpace(query)))
}

func fSongQueried(s spotify.FullTrack, query string) bool {
	return strings.Contains(strings.ToLower(s.Name), strings.ToLower(strings.TrimSpace(query)))
}

func sSongQueried(s spotify.SavedTrack, query string) bool {
	return strings.Contains(strings.ToLower(s.Name), strings.ToLower(strings.TrimSpace(query)))
}

func removeTagsFromQuery(query string) string {
	query = strings.ReplaceAll(query, "@latest", "")
	query = strings.ReplaceAll(query, "@liked", "")

	return query
}

func queryHasTags(query string) bool {
	return strings.Contains(query, "@latest") || strings.Contains(query, "@liked")
}

func (params *advancedSearchParams) parseTags() {
	params.Liked = strings.Contains(params.Query, "@liked")
	params.Latest = strings.Contains(params.Query, "@latest")
	params.Query = removeTagsFromQuery(params.Query)
}
