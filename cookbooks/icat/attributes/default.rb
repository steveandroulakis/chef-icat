include_attribute 'apt'
include_attribute 'build-essential'
include_attribute 'subversion'
include_attribute 'java'
include_attribute 'glassfish'

default['icat']['glassfish_password'] = 'adminadmin'
default['java']['oracle']['accept_oracle_download_terms'] = true

