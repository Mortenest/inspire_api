#SWIFT IMAGE + vapor

FROM swift:4.1 AS builder

ADD ./ /app
WORKDIR /app
RUN swift package clean
RUN swift build -c release
RUN mkdir /app/bin
RUN mv `swift build -c release --show-bin-path` /app/bin

EXPOSE 8080

ENTRYPOINT ./bin/release/Run serve --hostname 0.0.0.0 --port 8080