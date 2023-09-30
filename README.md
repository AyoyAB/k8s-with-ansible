# Ansible playbook to build kubernetes on pi

This repository holds ansible files for installing
Kubernetes using ansible on hardware but it's only
tested on Raspberry PI.

It assumes you have the following hardware:

1. A RPI for use as a load balancer.
2. One or more RPIs for use as a master.
3. One or mor RPIs for use as a worker.

The inventory "example" uses three masters and 9 workers
together with one load balancer.
If you have more or less hardware, create a new inventory under inventories/
and adjust the inventory file accordingly.

There are optional components to install which are controlled by
ansible variables. These are defined in the inventory group vars.

# Load Balancer

The load balancer can be installed on a debian server (e.g. Raspberry PI) 
and is used for infrastructure (load balancing both api server and 
incoming traffic).

HAProxy is be used for load balancing.
The status interface of HAproxy is found at [infra1.k8s1.example.com:1936/stats](infra1.k8s1.example.com:1936/stats) 
with default credentials `admin:password`.

The load balancer installation can be controlled with the following parameters:

| Variable                 | Description                                    | Default    |
|--------------------------|------------------------------------------------|------------|
| haproxy_stats_username   | HAProxy status page username.                  | `admin`    |
| haproxy_stats_password   | HAProxy status page password.                  | `password` |
| configure_ufw            | Configure UFW port openings.                   | `false`    |

# Disconnected registry

In disconnected environments you normally have a docker registry which will 
supply all the OKD images.

To use a disconnected registry, set the following parameters:

| variable                                | description                                                                                     |
|-----------------------------------------|-------------------------------------------------------------------------------------------------|
| use_disconnected_registry               | Boolean. Indicating a registry should be used. Example: true                                    |
| disconnected_registry_trust_bundle_file | String. Filename of the root CA for the registry. Example: ./openshift-ca/example.crt           |
| disconnected_registries                 | Array of objects. Mirror registries.                                                            |
| disconnected_registries.source          | String. URL that will be replaced with mirror. Example: quay.io/openshift/okd                   |
| disconnected_registries.mirrors         | Array of strings. URL to mirror registry. Example: registry.okd4.example.com:5011/openshift/okd |

# Pull-through-cache

In disconnected environments you normally have a docker registry which will 
supply all the OKD images. The pull-through-cache will simulate that and 
should also, if you have a faster cache than your Internet connection,
improve your installation time.

In [AyoyAB/okd-with-ansible/hack/docker-proxy](https://github.com/AyoyAB/okd-with-ansible/tree/main/hack/docker-proxy)
there is Makefile that can create the certificates and docker containers needed for that.
The certificates will be placed under `openshift-ca` and will need to be copied 
to the docker machine. Note that the hostname `registry.okd4.example.com` needs
to be setup in DNS.

| Usage          | description                                     |
|----------------|-------------------------------------------------|
| make ca        | creates both CA and registry certificates       |
| make quay.io   | creates the docker proxy registry for quay.io   |
| make docker.io | creates the docker proxy registry for docker.io |

# Preparation

1.  Setup DNS with the following entries (of course, adjust 
    addresses to your infrastructure):
    
    | hostname                      | Address                        |
    |-------------------------------|--------------------------------| 
    | infra1.k8s1.example.com       | 192.168.60.180                 |
    | api-int.k8s1.example.com      | CNAME infra1.k8s1.example.com  |
    | api.k8s1.example.com          | CNAME infra1.k8s1.example.com  |
    | apps.k8s1.example.com         | CNAME infra1.k8s1.example.com  |
    | *.apps.k8s1.example.com       | CNAME infra1.k8s1.example.com  |
    | master1.k8s1.example.com      | 192.168.60.181                 |
    | master2.k8s1.example.com	     | 192.168.60.182                 |
    | master3.k8s1.example.com	     | 192.168.60.183                 |
    | worker1.k8s1.example.com      | 192.168.60.184                 |

    If you're using pihole (as I do), increase rate limiting, create `/etc/dnsmasq.d/99-openshift.conf`
    with the following content and restart dns (`pihole restartdns`)
    ```
    address=/.apps.k8s1.example.com/192.168.60.180
    ```

2.  Create a [new image](images/README.md) for the rasperry pi with enabled ssh and boot it up.

3.  Create the SSH key, to be included in the installation.
    ```bash
    ssh-keygen -t rsa -b 4096 -C "john+github@ayoy.se" -f $HOME/.ssh/id_ansible
    ```

## Installation

The kubernets version that will be installed is defined int he inventories file,
parameter `kubernetes_version`.

Create the master and the nodes:
```bash
CLUSTER_NAME=example make cluster
```

## ArgoCD

The installation finishes off by installing [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
which later installs all the application. By default it uses 
[my home cluster repo](https://github.com/smuda/home-cluster-argo.git),
which might not be the best thing for you.

## Single master operation
This repository is designed for running multiple dedicated 
masters and nodes. If you are running a single-master setup,
remember to remove the NoSchedule taint on the master.

```bash
kubectl taint node master1 node-role.kubernetes.io/master:NoSchedule-
```
