# Ansible playbook to build kubernetes on pi

## Create the SSH key
```bash
ssh-keygen -t rsa -b 4096 -C "john+github@ayoy.se" -f $HOME/.ssh/id_ansible
```

## Create the master and the nodes
```bash
ansible-playbook -i hosts -v deploy-upstream-k8s.yml --extra-vars "ansible_become_pass=raspberry"
```

## Use containerd instead of docker
```bash
ansible-playbook -i hosts -v deploy-upstream-k8s.yml --extra-vars "ansible_become_pass=raspberry container_env=containerd"
```

## Specify kubernetes version instead of using "stable-1" = latest stable
kubernetes_version
```bash
ansible-playbook -i hosts -v deploy-upstream-k8s.yml --extra-vars "ansible_become_pass=raspberry kubernetes_version=1.19.5"
```

## Upgrade Raspian to 64-bit kernel
Include the variable use_64bit.

```bash
ansible-playbook -i hosts -v deploy-upstream-k8s.yml --extra-vars "ansible_become_pass=raspberry use_64bit=true"
```

## Single master operation
This repository is designed for running multiple dedicated 
masters and nodes. If you are running a single-master setup,
remember to remove the NoSchedule taint on the master.

```bash
kubectl taint node master1 node-role.kubernetes.io/master:NoSchedule-
```

## Preloading images
All *.tar.gz files found in docker-images-to-pre-load directory
will be copied to all masters and nodes and pre-loaded into
docker/containerd.
