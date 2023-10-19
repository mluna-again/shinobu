# How to run this server

1. Install go.
2. Build the project with `go build`
3. Export your spotify API credentials with the following format:
    a) SPOTIFY_ID=<your client ID>
    b) SPOTIFY_SECRET=<you spotify secret>
4. Run the server with: `./bop`
5. Follow the printed instructions to authenticated.
6. Start making requests :)

# Available endpoints:

1. POST /search
Search for songs, albums and playlists.
> You can use the following prefixes in your queries:
> "a:" will find only albums, "s:" will find only tracks and "l:" will find only playlists.
> No prefix means search for all three of them.

Request:
`
{
    "query": "newjeans"
}
`

Response:
`
[
    {
        "artist": "NewJeans",
        "display_name": "ETA",
        "id": "..."
    },
    ...
]
`

2. POST /play
Plays a song, album or playlist.

Request:
`
{
    "item": "<id>",
    "type": "track|album|playlist"
}
`

4. POST /pause
Play/pause current song.

5. POST /next
Skip current song.

4. POST /prev
Play previous song.

5. GET /status
Get info about current song.
Response format is the same as with the search, except its only one item.

6. POST /restart
Restarts the current song.

7. GET /queue
Get user queue. Max items returned is 20.
Response format is the same as with the search.

8. POST /addToLiked
Add a song to user's liked songs.
If body is empty, it uses the current song.
If song is already liked this endpoint does nothing.
Request:
`
{
    "ID": "<id>"
}
`

8. POST /removeFromLiked
Remove a song from user's liked songs.
If body is empty, it uses the current song.
Request:
`
{
    "ID": "<id>"
}
`
