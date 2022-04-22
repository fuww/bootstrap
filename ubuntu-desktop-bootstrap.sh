#!/bin/bash

if [[ $(id -u) -ne 0 ]]; 
  then echo "Ubuntu dev bootstrapper, prepares all the things -- run as root...";
  exit 1; 
fi

# https://www.google.com/linuxrepositories/
# https://www.microsoft.com/net/core#linuxubuntu
# https://code.visualstudio.com/docs/setup/linux
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
# https://yarnpkg.com/lang/en/docs/install/
# https://golang.org/doc/install#tarball

# Example: https://github.com/paulkohler/ubuntu-linux-bootstrap/blob/master/bootstrap.sh
# this file:

echo "Update and upgrade all the things..."

apt-get update -y

# Go

VERSION=1.18.1
OS=linux
ARCH=amd64
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz -O /tmp/go$VERSION.$OS-$ARCH.tar.gz
tar -C /usr/local -xzf /tmp/go$VERSION.$OS-$ARCH.tar.gz

# Using "~" in sudo context will get "/root" so wild guess the profile path:
USERS_PROFILE_FILENAME=/home/${SUDO_USER}/.profile
if grep -Fq "/usr/local/go/bin" $USERS_PROFILE_FILENAME
then
    echo "GO path found in $USERS_PROFILE_FILENAME"
else
    echo '
export PATH=$PATH:/usr/local/go/bin
' >> $USERS_PROFILE_FILENAME
fi

sudo apt autoremove -y

cat << EOF

# now....

# code --install-extension ms-dotnettools.csharp
# code --install-extension golang.go
# code --install-extension dbaeumer.vscode-eslint
# code --install-extension HookyQR.beautify
# code --list-extensions

# git setup:

# git config --global user.email "you@example.com"
# git config --global user.name "Your Name"

# ssh-keygen -t rsa -b 4096 -C "you@example.com"

# eval "\$(ssh-agent -s)"
# ssh-add ~/.ssh/id_rsa
# xclip -sel clip < ~/.ssh/id_rsa.pub

# now go to https://github.com/settings/keys

# also check docker... you may need to login again for groups to sort out
# try >> docker run hello-world

# To use GO straight up, get the path:
source ~/.profile

EOF
