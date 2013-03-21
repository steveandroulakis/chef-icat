chef-icat
=========
A chef cookbook for deploying ICAT

Works on Vagrant's Lucid32 box thus far.

Follow the [vagrantup.com/v1/docs/getting-started/index.html](Vagrant getting started guide) up to the point of adding the lucid32 box, then follow the commands below.

```
git clone https://github.com/steveandroulakis/chef-icat.git
cd chef-icat/
git submodule init
git submodule update
vagrant up
```

* TODO: set up paths for asadmin and starting/stopping db
* TODO: clean up hard-coded paths in recipe
* TODO: test on other VMs that aren't vagrant's lucid32 box
* TODO: make work on repeated calls of chef
* TODO: make more paths settable via external chef node configuration (eg. admin creds)
