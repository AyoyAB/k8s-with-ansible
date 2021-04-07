# README for using CentOS

## Base image
The base image used for testing is the minimal image.

## Ansible and CentOS
For ansible to work well with CentOS the
package redhat-lsb-core must be installed.

```
yum -y install redhat-lsb-core
```
Run visudo and add the following line:
```
pi      ALL=NOPASSWD: ALL
```
