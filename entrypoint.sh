#!/bin/sh
set -e

# Fallback owner if the folder was created by root (e.g. Docker auto-created it)
PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

OWNER_UID=$(stat -c %u /workspace)
OWNER_GID=$(stat -c %g /workspace)

if [ "$OWNER_UID" = "0" ]; then
    echo "workspace is owned by root, handing it to ${PUID}:${PGID}"
    chown -R "${PUID}:${PGID}" /workspace
    OWNER_UID=$PUID
    OWNER_GID=$PGID
fi

# Run as whoever owns the folder on the host, so both sides can read/write
exec setpriv --reuid="$OWNER_UID" --regid="$OWNER_GID" --clear-groups "$@"
