# Creating images



## Create new base image from Raspbian
Raspbian is the default goto-operating system for Raspberry Pi.

1. Download raspbian lite
1. In mac, double click on img file.
1. Open the mounted boot volume in terminal
1. Create the empty file /boot/ssh
1. Create the file /boot/wpa_supplicant.conf with the following content
    ```
    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    update_config=1
    country=sv
    
    network={
        ssid="«your_SSID»"
        psk="«your_PSK»"
        key_mgmt=WPA-PSK
    }
    ```
1. Boot the raspberry and assign a static IP in your DHCP server.
1. Have fun!

## Create a new base image from Ubuntu for Raspberry PI
1. Download ubuntu ARM64 image.
1. Update user-data to set non-expiring passwords.
    ```
    chpasswd:
      expire: false
      list:
       - ubuntu:raspberry
    ```
