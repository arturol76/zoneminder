#!/bin/sh
#
# 20_apt_update.sh
#

if [ "$APT_UPDATE" == "1" ]; then
    echo "performing updates..."

    # Update repositories
    apt-get update

    # Perform Upgrade
    apt-get -y upgrade -o Dpkg::Options::="--force-confold"

    # Clean + purge old/obsoleted packages
    apt-get -y autoremove
else
    echo "updates disabled."
fi
