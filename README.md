# ReplayWeb.page with Docker

[ReplayWeb.page](https://github.com/webrecorder/replayweb.page) allows one to browse archived
websites. The project is available as a browser-based web application at https://replayweb.page/ .
Many will be able to use the app hosted there, but in some cases you may want to host your own,
e.g. to ease CORS or to inject your own scripts. This project provides a docker image to do so.

Note that you need to run ReplayWeb.page using HTTPs (or the web worker will refuse to start).
So in all practical cases, you'd want a reverse proxy in front of this doing SSL termination.

## `inject.js`

By default, the Javascript file `inject.js` will be loaded for each archive page, which gives
you the option to add site-specific hooks. We use this to e.g. disable client-side navigation.
By default this file is empty, so nothing will be injected, but you can mount the file
`/usr/share/nginx/html/inject.js` in the Docker container to add your own code.

## Build

To build this docker image, you need to supply the build argument `VERSION` for the ReplayWeb.page version
(without any `v` prefix). The app will be downloaded [from npm](https://www.npmjs.com/package/replaywebpage).
