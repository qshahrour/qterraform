#cloud-config
---
repo_update: true
repo_upgrade: all
package_reboot_if_required: true
users:
- default
runcmd:
  - hostnamectl set-hostname ${hostname}
packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - wget
  - gnupg
  - lsb-release
  - unzip
  - git
  - libnss-extrausers
  - cron
  - python3-pip
  - htop
  - netcat
  - tar
