FROM alpine:3.22 AS build
WORKDIR /app
COPY /app .
RUN apk update && \
    apk add npm && \
    npm install --omit=dev

FROM alpine:3.22
WORKDIR /app
RUN addgroup -S -g 1000 appgroup && adduser -S -u 1000 -G appgroup appuser
COPY --from=build /app .
RUN apk update && apk upgrade $$ \
    apk add --no-cache nodejs oath-toolkit-oathtool jq su-exec && \
    rm -rf /var/cache/apk/* /tmp* && \
    addgroup -S -g 1000 appgroup && \
    adduser -S -u 1000 -G appgroup appuser && \
    chmod +x /app/entrypoint.sh /app/webdav.sh && \
    rm -rf /var/cache/apk/* /tmp* && \
    ln -s '/app/node_modules/@internxt/cli/bin/run.js' /usr/local/bin/internxt
EXPOSE 3005
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/app/webdav.sh"]