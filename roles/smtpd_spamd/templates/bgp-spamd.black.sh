#!/bin/sh
AS=65066

bgpctl show rib community ${AS}:666 | cut -c '10-' |
    sed -e '1,6d' -e 's/\/.*$//' -e 's/[ \*\>]*//' > /var/db/spamd.black

/usr/libexec/spamd-setup

# EOF
