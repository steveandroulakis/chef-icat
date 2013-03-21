chef-icat
=========
A chef cookbook for deploying ICAT

Most of the action occurs in [this file](https://github.com/steveandroulakis/chef-icat/blob/master/cookbooks/icat/recipes/default.rb)

Works on Ubuntu Lucid 32-bit (vagrant box) and Ubuntu Precise 64-bit (on the NeCTAR cloud). Untested for others so far. Red Hat Equivalents shouldn't work, but other versions of Ubuntu may.

Follow the [vagrantup.com/v1/docs/getting-started/index.html](Vagrant getting started guide) up to the point of adding the lucid32 box, then follow the commands below.

```
git clone https://github.com/steveandroulakis/chef-icat.git
cd chef-icat/
git submodule init
git submodule update
vagrant up
```

Or a non-Vagrant setup, appropriate for a server.

(as root)

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

* TODO: set up paths for asadmin and starting/stopping db
* TODO: clean up hard-coded paths in recipe
* TODO: test on other VMs that aren't vagrant's lucid32 box
* TODO: make work on repeated calls of chef
* TODO: make more paths settable via external chef node configuration (eg. admin creds)
