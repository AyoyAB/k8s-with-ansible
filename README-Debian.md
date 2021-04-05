# Running Debian

There are a number of commands that needs to be prepared on
Debian system to make this ansible script work.

```bash
apt-get install -y openssh-server
systemctl enable ssh
usermod -aG sudo pi
```

Run visudo and add the following line:
```
pi      ALL=NOPASSWD: ALL
```
