#!/bin/bash

abuild-keygen -aqin

cat <<EOF > ~/.bash_profile
. /etc/profile
EOF