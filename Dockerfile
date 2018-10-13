FROM golang:1.8 as goimage
ENV SRC=/go/src/
RUN mkdir -p /go/src/
WORKDIR /go/src/go_docker
RUN go get -u github.com/labstack/echo/... && go get -u github.com/sirupsen/logrus
RUN git clone -b master --single-branch https://github.com/fernando-machado/go-with-docker /go/src/go_docker/ \
&& CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
go build -o bin/go_docker

FROM alpine:3.6 as baseimagealp
RUN apk add --no-cache bash
ENV WORK_DIR=/docker/bin
WORKDIR $WORK_DIR
COPY --from=goimage /go/src/go_docker/bin/ ./
ENTRYPOINT [ "/docker/bin/go_docker" ]
EXPOSE 8080