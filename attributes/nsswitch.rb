default['pam']['nsswitch'].tap do |nsswitch|
  nsswitch['passwd'] = %w(compat ldap)
  nsswitch['group'] = %w(compat ldap)
  nsswitch['shadow'] = %w(compat)
  nsswitch['gshadow'] = %w(files)

  nsswitch['hosts'] = %w(files dns)
  nsswitch['networks'] = %w(files)

  nsswitch['protocols'] = %w(db files)
  nsswitch['services'] = %w(db files)
  nsswitch['ethers'] = %w(db files)
  nsswitch['rpc'] = %w(db files)

  nsswitch['netgroup'] = %w(nis)
end
