FROM alpine:3.22 AS build
WORKDIR /app
COPY /app .
RUN apk update && \
    apk add npm && \
    npm install --omit=dev

FROM alpine:3.22
WORKDIR /app
COPY --from=build /app .
RUN apk update && \
    apk add nodejs oath-toolkit-oathtool --no-cache && \
    chmod +x /app/entrypoint.sh && \
    rm -rf /var/cache/apk/* /tmp* && \
    ln -s '/app/node_modules/@internxt/cli/bin/run.js' /usr/local/bin/internxt
EXPOSE 3005
CMD ["/app/entrypoint.sh"]