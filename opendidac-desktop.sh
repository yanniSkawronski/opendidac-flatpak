#!/bin/sh
# Chrome's setuid sandbox cannot work inside the Flatpak sandbox; the bwrap
# sandbox already provides isolation, so launch with --no-sandbox.
exec /app/lib/opendidac-desktop/opendidac_desktop --no-sandbox "$@"
