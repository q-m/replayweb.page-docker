ARG VERSION

FROM node:latest AS builder

# install app from npm, only keeping necessary files
RUN mkdir /app && \
    cd /app && \
    npm install "replaywebpage@${VERSION}" && \
    mv node_modules/replaywebpage/* . && \
    rm -Rf node_modules && \
    rm -Rf index.js src assets package.json README.md

# modify service worker to add injection script
RUN sed -i 's/\(injectScripts:\s*\[\)/\1"inject.js",/' /app/sw.js
# workaround for https://github.com/webrecorder/wabac.js/issues/105
RUN sed -i 's/if\s*(\s*!\s*\([a-zA-Z_]\+\)\(\.length)\s*return[^)]\+size of the file is not accessible\)/if(\1.canLoadOnDemand\&\&!\1\2/' /app/sw.js

FROM nginx:mainline-alpine-slim AS runner

COPY --from=builder /app /usr/share/nginx/html

COPY nginx.template /etc/nginx/templates/default.conf.template
COPY inject.js /usr/share/nginx/html/inject.js
