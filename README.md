# pam_chef_cookbook
============

Description
------------

The cookbook provides PAM configuration

Requirements
------------

none

Supported Platforms
------------

Ubuntu 16.04
Ubuntu 18.04
Debian 9
CentOS 7

Attributes
--------------

The file `attributes/nscd.rb` contains attributes for `templates/nscd.conf.erb`:
- `daemon` attributes for daemon entries
- `cache_names` attributes for cache entries

The file `attributes/nslcd.rb` contains attributes for `templates/nslcd.conf.erb` and `templates/centos/ldap.conf.erb`:
- platform specific user and group for nslcd
- ldap server location and credentials for it
- ssl settings for nslcd

The file `attributes/nsswitch.rb` contains attributes for `templates/nsswitch.conf.erb`

Dependencies
------------

none

License
-------

Proprietary
