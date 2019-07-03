service 'nscd' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
  subscribes :restart, 'template[/etc/nscd.conf]', :immediately
  subscribes :restart, 'template[/etc/nsswitch.conf]', :immediately
  subscribes :restart, 'template[/etc/openldap/ldap.conf]', :immediately
end

service 'nslcd' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
  subscribes :restart, 'template[/etc/nslcd.conf]', :immediately
  subscribes :restart, 'template[/etc/openldap/ldap.conf]', :immediately
end
