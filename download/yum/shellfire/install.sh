#!/usr/bin/env sh
set -e
set -u

repoFilePath='/etc/yum.repos.d/shellfire.repo'
repoFileContent='[shellfire]
name=shellfire
#baseurl=https://shellfire-dev.github.io/shellfire/download/yum/shellfire
mirrorlist=https://shellfire-dev.github.io/shellfire/download/yum/shellfire/mirrorlist
gpgkey=https://shellfire-dev.github.io/shellfire/download/yum/shellfire/RPM-GPG-KEY-shellfire
gpgcheck=1
enabled=1
protect=0'

if [ -t 1 ]; then
	printf '%s\n' "This script will install the yum repository 'shellfire'" "It will create or replace '$repoFilePath', update yum and display all packages in 'shellfire'." 'Press the [Enter] key to continue.'
	read -r garbage
fi

printf '%s' "$repoFileContent" | sudo -p "Password for %p is required to allow root to install '$repoFilePath': " tee "$repoFilePath" >/dev/null
sudo -p "Password for %p is required to allow root to update yum cache: " yum --quiet makecache
yum --quiet info shellfire 2>/dev/null
