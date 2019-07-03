case node['platform_family']
when 'debian'
  default['pam']['list_pkg'] = ['nscd', 'nslcd', 'libpam-ldapd', 'libnss-ldapd']

  default['pam']['pamd'].tap do |pamd|
    pamd['sshd'].tap do |sshd|
      sshd['auth'] = [
        {
          '@include' => 'common-auth',
        },
      ]
      sshd['account'] = [
        {
          'module_name' => 'pam_nologin.so',
          'control_flag' => 'required',
        },
        {
          '@include' => 'common-account',
        },
      ]
      sshd['session'] = [
        {
          'module_name' => 'pam_selinux.so',
          'module_arguments' => ['close'],
          'control_flag' => '[success=ok ignore=ignore module_unknown=ignore default=bad]',
        },
        {
          'module_name' => 'pam_loginuid.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_keyinit.so',
          'module_arguments' => ['force', 'revoke'],
          'control_flag' => 'optional',
        },
        {
          '@include' => 'common-session',
        },
        {
          'module_name' => 'pam_motd.so',
          'module_arguments' => ['motd=/run/motd.dynamic'],
          'control_flag' => 'optional',
        },
        {
          'module_name' => 'pam_motd.so',
          'module_arguments' => ['noupdate'],
          'control_flag' => 'optional',
        },
        {
          'module_name' => 'pam_mail.so',
          'module_arguments' => ['standard', 'noenv'],
          'control_flag' => 'optional',
        },
        {
          'module_name' => 'pam_mkhomedir.so',
          'module_arguments' => ['skel=/etc/skel', 'umask=0022'],
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_limits.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_env.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_env.so',
          'module_arguments' => ['user_readenv=1', 'envfile=/etc/default/locale'],
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_selinux.so',
          'module_arguments' => ['open'],
          'control_flag' => '[success=ok ignore=ignore module_unknown=ignore default=bad]',
        },
      ]
      sshd['password'] = [
        {
          '@include' => 'common-password',
        },
      ]
    end
  end
when 'rhel'
  default['pam']['list_pkg'] = ['nscd', 'nss-pam-ldapd', 'libselinux-python', 'libsemanage-python']

  default['pam']['pamd'].tap do |pamd|
    pamd['system-auth-ac'].tap do |system|
      system['auth'] = [
        {
          'module_name' => 'pam_env.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_unix.so',
          'module_arguments' => ['nullok', 'try_first_pass'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_succeed_if.so',
          'module_arguments' => ['uid >= 1000', 'quiet_success'],
          'control_flag' => 'requisite',
        },
        {
          'module_name' => 'pam_ldap.so',
          'module_arguments' => ['use_first_pass'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_deny.so',
          'control_flag' => 'required',
        },
      ]
      system['account'] = [
        {
          'module_name' => 'pam_unix.so',
          'module_arguments' => ['broken_shadow'],
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_localuser.so',
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_succeed_if.so',
          'module_arguments' => ['uid < 1000', 'quiet'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_ldap.so',
          'control_flag' => '[default=bad success=ok user_unknown=ignore]',
        },
        {
          'module_name' => 'pam_permit.so',
          'control_flag' => 'required',
        },
      ]
      system['password'] = [
        {
          'module_name' => 'pam_pwquality.so',
          'module_arguments' => ['try_first_pass', 'local_users_only', 'retry=3', 'authtok_type='],
          'control_flag' => 'requisite',
        },
        {
          'module_name' => 'pam_unix.so',
          'module_arguments' => ['md5', 'shadow', 'nullok', 'try_first_pass', 'use_authtok'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_ldap.so',
          'module_arguments' => ['use_authtok'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_deny.so',
          'control_flag' => 'required',
        },
      ]
      system['session'] = [
        {
          'module_name' => 'pam_keyinit.so',
          'module_arguments' => ['revoke'],
          'control_flag' => 'optional',
        },
        {
          'module_name' => 'pam_limits.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_systemd.so',
          'control_flag' => 'optional',
          'ignore_log' => true,
        },
        {
          'module_name' => 'pam_mkhomedir.so',
          'module_arguments' => ['umask=0077'],
          'control_flag' => 'optional',
        },
        {
          'module_name' => 'pam_succeed_if.so',
          'module_arguments' => ['service in crond', 'quiet', 'use_uid'],
          'control_flag' => '[success=1 default=ignore]',
        },
        {
          'module_name' => 'pam_unix.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_ldap.so',
          'control_flag' => 'optional',
        },
      ]
    end
    pamd['password-auth-ac'].tap do |password|
      password['auth'] = [
        {
          'module_name' => 'pam_env.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_unix.so',
          'module_arguments' => ['nullok', 'try_first_pass'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_succeed_if.so',
          'module_arguments' => ['uid >= 1000', 'quiet_success'],
          'control_flag' => 'requisite',
        },
        {
          'module_name' => 'pam_ldap.so',
          'module_arguments' => ['use_first_pass'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_deny.so',
          'control_flag' => 'required',
        },
      ]
      password['account'] = [
        {
          'module_name' => 'pam_unix.so',
          'module_arguments' => ['broken_shadow'],
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_localuser.so',
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_succeed_if.so',
          'module_arguments' => ['uid < 1000', 'quiet'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_ldap.so',
          'control_flag' => '[default=bad success=ok user_unknown=ignore]',
        },
        {
          'module_name' => 'pam_permit.so',
          'control_flag' => 'required',
        },
      ]
      password['password'] = [
        {
          'module_name' => 'pam_pwquality.so',
          'module_arguments' => ['try_first_pass', 'local_users_only', 'retry=3', 'authtok_type='],
          'control_flag' => 'requisite',
        },
        {
          'module_name' => 'pam_unix.so',
          'module_arguments' => ['md5', 'shadow', 'nullok', 'try_first_pass', 'use_authtok'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_ldap.so',
          'module_arguments' => ['use_authtok'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_deny.so',
          'control_flag' => 'required',
        },
      ]
      password['session'] = [
        {
          'module_name' => 'pam_keyinit.so',
          'module_arguments' => ['revoke'],
          'control_flag' => 'optional',
        },
        {
          'module_name' => 'pam_limits.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_systemd.so',
          'control_flag' => 'optional',
          'ignore_log' => true,
        },
        {
          'module_name' => 'pam_mkhomedir.so',
          'module_arguments' => ['umask=0077'],
          'control_flag' => 'optional',
        },
        {
          'module_name' => 'pam_succeed_if.so',
          'module_arguments' => ['service in crond', 'quiet', 'use_uid'],
          'control_flag' => '[success=1 default=ignore]',
        },
        {
          'module_name' => 'pam_unix.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_ldap.so',
          'control_flag' => 'optional',
        },
      ]
    end
    pamd['fingerprint-auth-ac'].tap do |fingerprint|
      fingerprint['auth'] = [
        {
          'module_name' => 'pam_env.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_fprintd.so',
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_deny.so',
          'control_flag' => 'required',
        },
      ]
      fingerprint['account'] = [
        {
          'module_name' => 'pam_unix.so',
          'module_arguments' => ['broken_shadow'],
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_localuser.so',
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_succeed_if.so',
          'module_arguments' => ['uid < 1000', 'quiet'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_ldap.so',
          'control_flag' => '[default=bad success=ok user_unknown=ignore]',
        },
        {
          'module_name' => 'pam_permit.so',
          'control_flag' => 'required',
        },
      ]
      fingerprint['password'] = [
        {
          'module_name' => 'pam_deny.so',
          'control_flag' => 'required',
        },
      ]
      fingerprint['session'] = [
        {
          'module_name' => 'pam_keyinit.so',
          'module_arguments' => ['revoke'],
          'control_flag' => 'optional',
        },
        {
          'module_name' => 'pam_limits.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_systemd.so',
          'control_flag' => 'optional',
          'ignore_log' => true,
        },
        {
          'module_name' => 'pam_mkhomedir.so',
          'module_arguments' => ['umask=0077'],
          'control_flag' => 'optional',
        },
        {
          'module_name' => 'pam_succeed_if.so',
          'module_arguments' => ['service in crond', 'quiet', 'use_uid'],
          'control_flag' => '[success=1 default=ignore]',
        },
        {
          'module_name' => 'pam_unix.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_ldap.so',
          'control_flag' => 'optional',
        },
      ]
    end
    pamd['smartcard-auth-ac'].tap do |smartcard|
      smartcard['auth'] = [
        {
          'module_name' => 'pam_env.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_pkcs11.so',
          'module_arguments' => ['nodebug', 'wait_for_card'],
          'control_flag' => '[success=done ignore=ignore default=die]',
        },
        {
          'module_name' => 'pam_deny.so',
          'control_flag' => 'required',
        },
      ]
      smartcard['account'] = [
        {
          'module_name' => 'pam_unix.so',
          'module_arguments' => ['broken_shadow'],
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_localuser.so',
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_succeed_if.so',
          'module_arguments' => ['uid < 1000', 'quiet'],
          'control_flag' => 'sufficient',
        },
        {
          'module_name' => 'pam_ldap.so',
          'control_flag' => '[default=bad success=ok user_unknown=ignore]',
        },
        {
          'module_name' => 'pam_permit.so',
          'control_flag' => 'required',
        },
      ]
      smartcard['password'] = [
        {
          'module_name' => 'pam_pkcs11.so',
          'control_flag' => 'required',
        },
      ]
      smartcard['session'] = [
        {
          'module_name' => 'pam_keyinit.so',
          'module_arguments' => ['revoke'],
          'control_flag' => 'optional',
        },
        {
          'module_name' => 'pam_limits.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_systemd.so',
          'control_flag' => 'optional',
          'ignore_log' => true,
        },
        {
          'module_name' => 'pam_mkhomedir.so',
          'module_arguments' => ['umask=0077'],
          'control_flag' => 'optional',
        },
        {
          'module_name' => 'pam_succeed_if.so',
          'module_arguments' => ['service in crond', 'quiet', 'use_uid'],
          'control_flag' => '[success=1 default=ignore]',
        },
        {
          'module_name' => 'pam_unix.so',
          'control_flag' => 'required',
        },
        {
          'module_name' => 'pam_ldap.so',
          'control_flag' => 'optional',
        },
      ]
    end
  end
end
