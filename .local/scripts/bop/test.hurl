POST http://localhost:8888/search
{
  "query": "{{song}}"
}
HTTP 200
[Captures]
song_id: jsonpath "$[0].id"

POST http://localhost:8888/play
{
  "item": "{{song_id}}"
}
