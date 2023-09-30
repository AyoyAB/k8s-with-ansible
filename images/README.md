# Creating images

## Create new base image from Raspbian
Raspbian is the default goto-operating system for Raspberry Pi.

1.  Download raspbian lite
2.  In mac, double click on img file.
3.  Open the mounted boot volume in terminal
4.  Create the empty file /boot/ssh
5.  Create the encrypted password for the k8s user:
    ```
    echo 'password' | openssl passwd -6 -stdin
    ```
5.  Create the file /boot/userconf.txt with `k8s:<encrypted password>`, for example:
    ```
    k8s:$6$KeJyp11i9plG.N66$h5acCGzCAYa62X/uDkC4fh3RQz/imlCMSyCJW6UXPBPeLktIjA7AsG6uhSgmE7PgValHGt5iWrDztvj5E/nGy0
    ```
6.  Unmount the image and write to SD card.
7.  Boot the raspberry and assign a static IP in your DHCP server.
8.  Have fun!
