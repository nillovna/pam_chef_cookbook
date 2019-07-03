template '/etc/nscd.conf' do
  source 'nscd.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    daemon: node['pam']['nscd']['daemon'],
    cache_names: node['pam']['nscd']['cache_names']
  )
end

template '/etc/nslcd.conf' do
  source 'nslcd.conf.erb'
  owner 'root'
  group 'root'
  mode '0640'
  variables(nslcd: node['pam']['nslcd'])
end

template '/etc/nsswitch.conf' do
  source 'nsswitch.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(nsswitch: node['pam']['nsswitch'])
end

node['pam']['pamd'].keys.each do |file|
  template "/etc/pam.d/#{file}" do
    source 'pamd.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(pamd: node['pam']['pamd'][file])
  end
end
