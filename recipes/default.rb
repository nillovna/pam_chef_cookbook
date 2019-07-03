# Cookbook:: pam_chef_cookbook
# Recipe:: default
#
# Copyright:: 2018, IQOption, All Rights Reserved.

case node['platform_family']
when 'debian'
  include_recipe 'pam_chef_cookbook::debian'
when 'rhel'
  include_recipe 'pam_chef_cookbook::rhel'
else
  Chef::Log.warn('Your platform family is not debian or rhel')
  return
end

include_recipe 'pam_chef_cookbook::services'
