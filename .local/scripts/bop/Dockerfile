FROM docker.io/golang:1.23.5-alpine

WORKDIR /app

RUN apk add "chafa=~1.14"
RUN go install github.com/pressly/goose/v3/cmd/goose@latest

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go install

CMD ["/app/start.sh"]
