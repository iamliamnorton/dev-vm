# Dev VM

This is a dev ready Vagrant Box with Docker on Ubuntu 14.04.

## Installation

    $ vagrant up

You will be promoted for your password, since this box is configured to use NFS
for the /vagrant volume, which is *considerably* faster than the default
vboxfs.

## Usage

    $ vagrant ssh

Now use docker, as it's on the machine itself. SSH forwarding is enabled by
default.

Put the following line in your `/etc/hosts` file to access in browser at `http://dev.vm/`.

    192.168.21.11 dev.vm

### File storage

The symlink in your home directory called ~/projects points into the /vagrant
directory. The /vagrant directory is where the Vagrantfile is stored on your
Mac. Put your projects in here if you want them to persist between rebuilds of
the VM.

### Provisioning

Currently the VM is provisioned with Docker 1.8.1.

    $ vagrant provision

Or alternatively:

    $ vagrant destroy -f
    $ vagrant up
