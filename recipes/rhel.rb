include_recipe 'pam_chef_cookbook::install'
include_recipe 'pam_chef_cookbook::configure_selinux'
include_recipe 'pam_chef_cookbook::configure_ldap_common'
include_recipe 'pam_chef_cookbook::configure_ldap_rhel'
