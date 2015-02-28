Tarsnap for Debian and Ubuntu
=============================

Create your own tarsnap client .deb for Debian or Ubuntu.

Tested on Debian 7.0, Ubuntu 12.04, and Ubuntu 14.04.

Quickstart
----------

Package the default version of tarsnap:

    ./build.sh

Package a specific version of tarsnap:

    ./build.sh 1.0.35

Backup a system:

    dpkg -i tarsnap*.deb
    sudo tarsnap-keygen --machine $(hostname) \
        --keyfile /etc/tarsnap.key \
        --user tarsnap-user@example.com
    sudo tarsnap -cf etc-$(date +%Y-%m-%d-%H-%M) /etc

Details
-------

This project doesn't include the tarsnap client source code. Instead,
`build.sh` downloads it from tarsnap.com.

While it is safest to build packages as a non-privileged user, if you
like to live dangerously `build.sh` installs dependencies when run by
a user with sudo privileges.

To build as a non-privileged user:

    sudo apt-get install build-essential debhelper lintian
    sudo apt-get install libssl-dev zlib1g-dev e2fslibs-dev
    sudo apt-get install libacl1-dev libattr1-dev libbz2-dev liblzma-dev
    sudo useradd -m builduser
    sudo cp -r tarsnap-deb/ ~builduser/tarsnap-deb
    sudo chown -R builduser: ~builduser/tarsnap-deb
    sudo -i -u builduser
    cd ~/tarsnap-deb
    ./build.sh
    mv -v *.deb /tmp
    exit
    ls /tmp/*.deb
