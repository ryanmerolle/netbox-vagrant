# netbox-vagrant

**Nuthshell:** Quickest NetBox install for Demo or Production(*recommended that you tweak slightly for production*).

This repository houses the components needed to build [NetBox](https://github.com/digitalocean/netbox/) using [Vagrant](https://www.vagrantup.com/intro) and [VirtualBox](https://www.virtualbox.org). It is a work in progress; please submit a bug report for any issues you encounter.

[Vagrant Getting Started](https://www.vagrantup.com/intro/getting-started/index.html) - Quick setup requires installing VirtualBox and Vagrant (selected your supported OS in the links below).

  * [VirtualBox](https://www.virtualbox.org/wiki/Downloads) - You can replace with other virtual platforms.  See Vagrant Getting Started above.
  * [Vagrant](https://www.vagrantup.com/downloads.html)

## Quickstart

To get NetBox up and running:

 1. Install Virtual Platform & Vagrant (if not installed already)
 2. Clone [netbox-vagrant git repo](https://github.com/ryanmerolle/netbox-vagrant/) ```# git clone https://github.com/ryanmerolle/netbox-vagrant/ .``` or just download both [Vagrantfile](Vagrantfile) & [bootstrap.sh](bootstrap.sh) and place in the directory you want to launch vagrant from.
 3. Navigate to local repo directory & start vagrant
```# vagrant up```
 4. Log into VM (optional)
```# vagrant ssh```
 5. Play with Netbox demo in browser of choice [http://netbox.localhost:8080](http://netbox.localhost:8080) (Admin credentials use "admin" for userid and password - can be changed & credentials do not have quotes)
 6. (Optional) [NAPALM Config](http://netbox.readthedocs.io/en/stable/configuration/optional-settings/#napalm_username), [Email Config](http://netbox.readthedocs.io/en/stable/configuration/optional-settings/#email), [LDAP](http://netbox.readthedocs.io/en/stable/installation/ldap/)

## Upgrading
The [normal NetBox upgrade process](https://github.com/digitalocean/netbox/blob/develop/docs/installation/upgrading.md) can be followed using the instructions to Clone the Git Repository (latest master release).

## Netbox Configuration Used
The [NetBox installation](https://github.com/digitalocean/netbox/blob/develop/docs/installation/netbox.md) process is followed leveraging:

* VM Memory: 2048 (edit Vagrantfile if you would like to change)
* VM CPUs: 1 (edit Vagrantfile if you would like to change)
* Ubuntu Xenial64 (updated)
* Python 3 (deprecated python2)
* GIT - Cloning the Netbox latest master release from github (as opposed to downloading a tar of a particular release)
* Ngnix (deprecated Apache)

## Security
* Netbox/Django superuser account is ```admin``` with a password ```admin``` and an email of ```admin@example.com``` (can be changed after startup)
* SECRET_KEY is randomly generated using generate_secret_key.py
* Postgres DB is setup using account is "nebox" with a password "J5brHrAXFLQSif0K" and the database "netbox" using the default port (all without quotes and can be changed after startup)
* [Forwarded Ports](https://www.vagrantup.com/docs/networking/forwarded_ports.html) - to add additional VM access / port forwarding (ssh, remote psql, etc)
* [Vagrant Credentials](https://www.vagrantup.com/docs/boxes/base.html#default-user-settings) - to understand credentials used for vagrant / Ubuntu VM

## Notes
* [bootstrap.sh](bootstrap.sh) can be used to bootstrap any Ubuntu Xenial setup & not just Vagrant (with slight tweaking)
* Additional Support Resources include:
 * [NetBox Github page](https://github.com/digitalocean/netbox/)
 * [NetBox Read the Docs](http://netbox.readthedocs.io/en/stable/)
 * [NetBox-discuss mailing list](https://groups.google.com/forum/#!forum/netbox-discuss)
 * [NAPALM Github page](https://github.com/napalm-automation/napalm/)
 * [NAPALM Read the Docs](https://napalm.readthedocs.io/)
 * [Join the Network to Code community on Slack](https://networktocode.herokuapp.com) - Once setup join the **#netbox** room for help.  I'm **ryanmerolle** & usually in this slack room.
