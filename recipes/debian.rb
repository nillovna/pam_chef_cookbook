apt_update

include_recipe 'pam_chef_cookbook::install'
include_recipe 'pam_chef_cookbook::configure_systemd'
include_recipe 'pam_chef_cookbook::configure_ldap_common'
