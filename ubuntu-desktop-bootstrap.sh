# This script configures the system (executed from preseed late_command)
# 2013-02-14 / Philipp Gassmann / gassmann@puzzle.ch

set -x

# Ensure proper logging
if [ "$1" != "stage2" ]; then
  mkdir /root/log
  /bin/bash /root/desktop-bootstrap.sh 'stage2' &> /root/log/desktop-bootstrap.log
  exit
fi

RESOURCES="http://example.com/resources"


###### PACKAGE MANAGEMENT & ADDITIONAL PACKAGES ######
######################################################

# Add oracle-java-installer PPA:
add-apt-repository -y ppa:webupd8team/java

# add gimp 2.8 repository
add-apt-repository -y ppa:otto-kesselgulasch/gimp

# accept oracle java license
echo 'oracle-java7-installer shared/accepted-oracle-license-v1-1 select true' | sudo /usr/bin/debconf-set-selections

# Install packages from added repositories
apt-get update
apt-get install -y  gimp gimp-help-de oracle-java7-installer


# Install appropriate graphics and wlan drivers
kernel=`rpm -q kernel | sed 's/kernel-//'` # version of installed kernel, not active kernel
lspci | grep VGA | grep -iq nvidia && apt-get install -y  nvidia-current-updates
lspci | grep VGA | grep -q ATI && apt-get install -y fglrx-updates

# Auto Install proprietary drivers:
jockey-text --auto-install


###### GENERAL SYSTEM SETTINGS ######
#####################################

# Set locale
cat > /etc/default/locale <<EOF
LANG=de_CH.UTF-8
LC_NUMERIC=de_CH.UTF-8
LC_TIME=de_CH.UTF-8
LC_MONETARY=de_CH.UTF-8
LC_MEASUREMENT=de_CH.UTF-8
EOF

# output from bash in not in German.
echo 'export LANG=C.UTF-8' >> /etc/bash.bashrc

# regenerate locales
locale-gen

# update apt-file db
apt-file update

# Disable update-notifier notifications:
sed -i /etc/update-notifier/hooks_seen -e '/apt-file-update/d'
sed -i /etc/update-notifier/hooks_seen -e '/nautilus-compare-notification/d'

date_s=`date +%s`
echo "apt-file-update $date_s 0" >> /etc/update-notifier/hooks_seen
echo "nautilus-compare-notification $date_s 0" >> /etc/update-notifier/hooks_seen

###### Custom ENVIRONMENT ######
################################

# removed

###### Prepare End User Configuration #####
###########################################

# get desktop-bootrap file
wget -qO /root/desktop-bootstrap-user.sh "http://example.com/ubuntu-desktop-bootstrap-user.sh"
chmod +x /root/desktop-bootstrap-user.sh

# Activate firstboot-custom (user setup)
wget -qO /etc/init/firstboot-custom.conf "http://example.com/firstboot-custom.conf"

# Installationsdatum speichern
date +%c > /root/install-date




















# #!/bin/bash

# # Example: https://wiki.ubuntu.com/Enterprise/WorkstationAutoinstallScripts

# if [[ $(id -u) -ne 0 ]]; 
#   then echo "Ubuntu dev bootstrapper, prepares all the things -- run as root...";
#   exit 1; 
# fi

# # https://www.google.com/linuxrepositories/
# # https://www.microsoft.com/net/core#linuxubuntu
# # https://code.visualstudio.com/docs/setup/linux
# # https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
# # https://yarnpkg.com/lang/en/docs/install/
# # https://golang.org/doc/install#tarball

# # Example: https://github.com/paulkohler/ubuntu-linux-bootstrap/blob/master/bootstrap.sh


# ###### PACKAGE MANAGEMENT & ADDITIONAL PACKAGES ######
# ######################################################

# echo "Update and upgrade all the things..."

# apt-get update -y

# # Go

# VERSION=1.18.1
# OS=linux
# ARCH=amd64
# wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz -O /tmp/go$VERSION.$OS-$ARCH.tar.gz
# tar -C /usr/local -xzf /tmp/go$VERSION.$OS-$ARCH.tar.gz

# # Using "~" in sudo context will get "/root" so wild guess the profile path:
# USERS_PROFILE_FILENAME=/home/${SUDO_USER}/.profile
# if grep -Fq "/usr/local/go/bin" $USERS_PROFILE_FILENAME
# then
#     echo "GO path found in $USERS_PROFILE_FILENAME"
# else
#     echo '
# export PATH=$PATH:/usr/local/go/bin
# ' >> $USERS_PROFILE_FILENAME
# fi

# sudo apt autoremove -y

# cat << EOF

# # now....

# # code --install-extension ms-dotnettools.csharp
# # code --install-extension golang.go
# # code --install-extension dbaeumer.vscode-eslint
# # code --install-extension HookyQR.beautify
# # code --list-extensions

# # git setup:

# # git config --global user.email "you@example.com"
# # git config --global user.name "Your Name"

# # ssh-keygen -t rsa -b 4096 -C "you@example.com"

# # eval "\$(ssh-agent -s)"
# # ssh-add ~/.ssh/id_rsa
# # xclip -sel clip < ~/.ssh/id_rsa.pub

# # now go to https://github.com/settings/keys

# # also check docker... you may need to login again for groups to sort out
# # try >> docker run hello-world

# # To use GO straight up, get the path:
# source ~/.profile

# EOF
