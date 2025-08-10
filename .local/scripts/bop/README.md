# How to run this server

0. Copy the .env file example with `cp .env.example .env`.
1. Make the appropriate changes to your .env file.
2. Start the server (see below).
3. Use `docker compose logs server` to get the authentication link and copy-paste it into your browser. Log in.
4. Done, probably.
5. Try using the TUI (see below).

## Start server
```sh
$ docker compose up -d
```

## Start TUI player
```sh
$ docker compose run --rm tui
```

## Use the bop CLI
```sh
$ docker compose run --rm tui bop help
```

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
## Requirements
1. postgresql (required)
2. chafa (optional)
