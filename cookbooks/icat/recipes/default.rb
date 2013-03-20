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

include_recipe 'build-essential'
include_recipe 'apt'

package "expect" do
  action :install
end

gem_package "ruby-shadow" do
  action :install
end

include_recipe 'glassfish'
include_recipe 'subversion'

group "glassfish-admin" do
  gid 99
end

user "glassfish3" do
  home "/home/glassfish3"
  gid 99
  shell "/bin/bash"
end

glassfish_domain "domain1" do
  port 8080
  admin_port 4848
  username "admin"
  password "adminadmin"
  password_file "testpassword"
end

glassfish_secure_admin "domain1 Remote Access" do
   domain_name "domain1"
   username "admin"
   password_file "testpassword"
   action :enable
end

directory "/home/glassfish3/" do
  mode 0755
  owner "glassfish3"
  action :create
end

# ENV['JAVA_HOME'] = "adminadmin"
# ENV['GLASSFISH_HOME'] = "glassfish"
# ENV['ICAT_HOME'] = "ii"
# ENV['DB_HOME'] = "ii"
# ENV['ICAT_HOME'] = "dq"
ENV['AS_ADMIN_USER'] = "admin"
ENV['AS_ADMIN_PASSWORDFILE'] = "/testpassword"

link "/home/glassfish3/glassfish3" do
  to "/usr/local/glassfish"
end

# checkout svn
bash "svn_checkout_icat" do
  cwd "/home/glassfish3"
  user "glassfish3"
  group "glassfish-admin"
  code <<-EOH
    svn co https://icatproject.googlecode.com/svn/ops/icat42
    EOH
end

# copy properties files
bash "copy_properties" do
  code <<-EOH
    cp /home/glassfish3/icat42/icat.ear.config/icat.properties /home/glassfish3/glassfish3/glassfish/domains/domain1/config/
    cp /home/glassfish3/icat42/authn_db.ear.config/authn_db.properties /home/glassfish3/glassfish3/glassfish/domains/domain1/
    EOH
end

# asadmin start­database ­­dbhost 127.0.0.1
glassfish_asadmin "start-database --dbhost 127.0.0.1" do
   domain_name 'domain1'
end

# run scripts.. create.sh
# bash "shell glassfish login automation" do
#   code <<-EOH
#     cat >logincmds <<EOF
#     spawn /usr/local/glassfish/glassfish/bin/asadmin login
#     expect -ex {Enter admin user name }
#     send -- {admin\n}
#     expect -ex {Enter admin password}
#     send -- {adminadmin\n}
#     interact
#     EOH
# end

# # run scripts.. create.sh
# bash "shell glassfish login" do
#   code <<-EOH
#     expect -f /logincmds
#     EOH
# end

# glassfish_asadmin "login" do
#    username "admin"
#    password_file "/testpassword"    
#    domain_name 'domain1'
# end

# run scripts.. create.sh
bash "create icat ear" do
  cwd "/home/glassfish3/icat42/icat.ear.config"
  code <<-EOH
    ./create.sh
    EOH
end

# run scripts.. create.sh
bash "create authn_db ear" do
  cwd "/home/glassfish3/icat42/authn_db.ear.config"
  code <<-EOH
    ./create.sh
    EOH
end

# deploy
glassfish_asadmin "deploy /home/glassfish3/icat42/authn_db.ear-1.0.0.ear" do
   username "admin"
   password_file "testpassword"    
   domain_name 'domain1'
end

glassfish_asadmin "deploy /home/glassfish3/icat42/icat.ear-4.2.0.ear" do
   username "admin"
   password_file "testpassword"    
   domain_name 'domain1'
end

# and usertable.sh
# hand-written because ij is not necessarily on the path
bash "create usertable" do
  cwd "/home/glassfish3/icat42/usertable_init"
  code <<-EOH
    java -jar /usr/local/glassfish/javadb/lib/derbyrun.jar ij passwd.sql
    EOH
end

# symlink log
