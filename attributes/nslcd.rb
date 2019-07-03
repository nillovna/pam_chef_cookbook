default['pam']['nslcd'].tap do |nslcd|
  nslcd['uid'] = 'nslcd'
  case node['platform_family']
  when 'debian'
    nslcd['gid'] = 'nslcd'
  when 'rhel'
    nslcd['gid'] = 'ldap'
    nslcd['sasl_nocanon'] = 'on'
  end

  nslcd['ldapservers'] = ['ldaps://ldap.example.com/']
  nslcd['base'] = 'dc=example,dc=com'
  nslcd['binddn'] = 'cn=readonly,dc=example,dc=com'
  nslcd['bindpw'] = 'REALLY_SECRET_PASSWORD'

  nslcd['ssl'] = 'on'
  nslcd['tls_reqcert'] = 'never'
end
