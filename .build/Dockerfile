FROM oven/bun:1

ARG GBRAIN_VERSION

RUN bun install -g "github:garrytan/gbrain#${GBRAIN_VERSION}"

COPY entrypoint.sh /usr/local/bin/gbrain-entrypoint.sh
RUN chmod +x /usr/local/bin/gbrain-entrypoint.sh

EXPOSE 3131

ENTRYPOINT ["/usr/local/bin/gbrain-entrypoint.sh"]