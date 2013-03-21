#
# Cookbook Name:: icat
# Recipe:: default
#
# Copyright 2013, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# add build tools like gcc
include_recipe 'build-essential'

# apt-get update
include_recipe 'apt'

# add ruby shadow for passwording
gem_package "ruby-shadow" do
  action :install
end

# install glassfish
include_recipe 'glassfish'

# install subversion
include_recipe 'subversion'

# add unix user
user "glassfish3" do
  home "/home/glassfish3"
  gid 99
  shell "/bin/bash"
end

# icat domain permissions
bash "domain permissions" do
  code <<-EOH
    mkdir -p /usr/local/glassfish/glassfish/domains/icat
    chmod -R 775 /usr/local/glassfish/glassfish/domains
    EOH
end

# create glassfish domain
# TODO: testpassword productionising
glassfish_domain "icat" do
  port 8080
  admin_port 4848
  username "admin"
  password "adminadmin"
  password_file "testpassword"
end

# enable secure admin so we can log in remotely
glassfish_secure_admin "icat Remote Access" do
   domain_name "icat"
   username "admin"
   password_file "testpassword"
   action :enable
end

# create glassfish3 user home directory
directory "/home/glassfish3/" do
  mode 0755
  owner "glassfish3"
  action :create
end

# add glassfish admin credentials to unix env to run icat's included scripts
ENV['AS_ADMIN_USER'] = "admin"
ENV['AS_ADMIN_PASSWORDFILE'] = "/testpassword"

link "/home/glassfish3/glassfish3" do
  to "/usr/local/glassfish"
end

# checkout ICAT from svn
bash "svn_checkout_icat" do
  cwd "/home/glassfish3"
  user "glassfish3"
  group "1001"
  code <<-EOH
    svn co https://icatproject.googlecode.com/svn/ops/icat42
    EOH
end

# copy properties files to glassfish domains
bash "copy_properties" do
  code <<-EOH
    cp /home/glassfish3/icat42/icat.ear.config/icat.properties /home/glassfish3/glassfish3/glassfish/domains/icat/config/
    cp /home/glassfish3/icat42/authn_db.ear.config/authn_db.properties /home/glassfish3/glassfish3/glassfish/domains/icat/
    EOH
end

# start derby dev database
glassfish_asadmin "start-database --dbhost 127.0.0.1" do
   domain_name 'icat'
end

# run icat scripts.. icat create.sh
bash "create icat ear" do
  cwd "/home/glassfish3/icat42/icat.ear.config"
  code <<-EOH
    ./create.sh
    EOH
end

# run icat scripts.. authn create.sh
bash "create authn_db ear" do
  cwd "/home/glassfish3/icat42/authn_db.ear.config"
  code <<-EOH
    ./create.sh
    EOH
end

# deploy icat's auth
# TODO: remove hard-coded path
glassfish_asadmin "deploy /home/glassfish3/icat42/authn_db.ear-1.0.0.ear" do
   username "admin"
   password_file "testpassword"    
   domain_name 'icat'
end

# deploy icat app
# TODO: remove hard-coded path
glassfish_asadmin "deploy /home/glassfish3/icat42/icat.ear-4.2.0.ear" do
   username "admin"
   password_file "testpassword"    
   domain_name 'icat'
end

# run ICAT user creation script
# hand-written because ij is not necessarily on the path
# TODO: remove hard-coded path
bash "create usertable" do
  cwd "/home/glassfish3/icat42/usertable_init"
  code <<-EOH
    java -jar /usr/local/glassfish/javadb/lib/derbyrun.jar ij passwd.sql
    EOH
end

# TODO: symlink log
