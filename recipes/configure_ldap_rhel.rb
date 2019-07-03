template '/etc/openldap/ldap.conf' do
  source 'ldap.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(nslcd: node['pam']['nslcd'])
end
