ICAT Deployment Chef Cookbook
=========
Builds an [ICAT](http://code.google.com/p/icatproject) metadata store server roughly based on this [README](https://icatproject.googlecode.com/svn-history/r2152/ops/icat42/readme.txt).

Most of the action occurs in [this file](https://github.com/steveandroulakis/chef-icat/blob/master/cookbooks/icat/recipes/default.rb).

Tested and working on Ubuntu Lucid 32-bit (vagrant box) and Ubuntu Precise 64-bit (on the NeCTAR cloud). Untested for other operating systems so far. Red Hat Equivalents shouldn't work, but other versions of Ubuntu after version 10 should.

Option 1: Deployment on your local machine with Vagrant
-------------------------------------------------------
Follow the [Vagrant getting started guide](http://vagrantup.com/v1/docs/getting-started/index.html) up to the point of adding the lucid32 box, then follow the commands below.

```
git clone https://github.com/steveandroulakis/chef-icat.git
cd chef-icat/
git submodule init
git submodule update
vagrant up
```

Option 2: Install on a server (non-vagrant chef build)
-------------------------------------------------------
Non-vagrant setup.

_Note: If your NeCTAR cloud node is complaining about not being able to resolve its hostname then fix it first before running this guide (add `hostname 127.0.0.1` to `/etc/hosts`). This is a NeCTAR cloud issue._

(run the following as root)

```
sudo true && curl -L https://www.opscode.com/chef/install.sh | sudo bash
sudo apt-get update
sudo apt-get install git-core
mkdir -p /var/chef-solo
cd /var/chef-solo
git clone https://github.com/steveandroulakis/chef-icat.git
cd chef-icat/
git submodule init
git submodule update
chef-solo -c solo.rb -j node.json
```

Usage
-------------------------------------------------------

Access the server by `http://<ip>:4848` and username:password `admin:adminadmin`.

To Do
-------------------------------------------------------

* TODO: make the start/stop glassfish-icat also work with the database
* TODO: clean up hard-coded paths in recipe
* TODO: test working after system restart
* TODO: make compatible with running chef multiple times (for later updates etc)
* TODO: make some paths and basic actions settable via external chef node configuration (eg. admin credentials)
* TODO: install python and python-suds module so ICAT's test.py works
