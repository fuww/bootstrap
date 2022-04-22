# Bootstrap Linux preseed scripts run after install of OS

for  the crypt hash and userpassword hash.

    sudo apt install whois
    mkpasswd -m sha-512 -S $(pwgen -ns 16 1) mypassword

# usage

run ubuntu installer from usb (or network)

make sure the config file is available on the internet and then pass it to the kernel at installation time with the following kernel argument:

    preseed/url=https://gitlab.com/fuww/bootstrap/-/raw/main/preseed-ubuntu-workstation-fu.cfg

or; create a custom ISO file and put it on a USB.
or; install cobbler, create a netboot image and use it with the preseed file.
