FROM golang:1.18-alpine

WORKDIR /go/src

COPY go.sum .

COPY go.mod .

RUN go get -d || true

COPY . .

RUN go build -o main.out main.go