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

gem_package "ruby-shadow" do
  action :install
end

include_recipe 'glassfish'


group "glassfish-admin" do
  gid 99
end

user "glassfish" do
  home "/home/glassfish3"
  gid 99
  shell "/bin/bash"
end

# ENV['AS_ADMIN_PASSWORD'] = "adminadmin" #node[:icat][:glassfish_password]

# bash "env_test0" do
#   code <<-EOH
#   echo $AS_ADMIN_PASSWORD
#   EOH
# end

# Example from git
# Create a basic domain that logs to a central graylog server
glassfish_domain "domain1" do
  port 8080
  admin_port 4848
  username "admin"
  password "adminadmin"
  password_file "testpassword"
  #extra_libraries ['https://github.com/downloads/realityforge/gelf4j/gelf4j-0.9-all.jar']
end
