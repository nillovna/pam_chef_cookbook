name 'pam'
maintainer 'Sofiya Podolskaya'
maintainer_email 's.nillovna@gmail.com'
license 'MIT'
description 'Provides LDAP auth with nscd and nslcd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'
chef_version '>= 13.1' if respond_to?(:chef_version)
supports 'ubuntu', '= 16.04'
supports 'ubuntu', '= 18.04'
supports 'debian', '= 9'
supports 'centos', '= 7'

issues_url 'https://github.com/nillovna/pam_chef_cookbook/issues'
source_url 'https://github.com/nillovna/pam_chef_cookbook'
