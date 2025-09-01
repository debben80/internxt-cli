FROM alpine:3.22 AS build
WORKDIR /app
COPY /app .
RUN apk -U upgrade && \
    apk add npm && \
    npm install --omit=dev

FROM alpine:3.22
ENV TZ Etc/UTC
WORKDIR /app
COPY --from=build /app .
RUN apk -U upgrade && \
    apk add --no-cache nodejs oath-toolkit-oathtool jq su-exec tzdata && \
    addgroup -S -g 1000 appgroup && \
    adduser -S -u 1000 -G appgroup appuser && \
    chmod +x /app/entrypoint.sh /app/webdav.sh /app/healthcheck.sh && \
    rm -rf /var/cache/apk/* /tmp* && \
    ln -s '/app/node_modules/@internxt/cli/bin/run.js' /usr/local/bin/internxt
EXPOSE 3005
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/app/webdav.sh"]
HEALTHCHECK --interval=60s --timeout=10s --start-period=15s --retries=2 \
    CMD /app/healthcheck.sh
