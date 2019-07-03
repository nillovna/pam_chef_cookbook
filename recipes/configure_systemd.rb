systemd_unit 'nslcd.service' do
  content(Unit: {
            Description: 'Naming services LDAP client daemon',
            After: 'syslog.target network.target',
          },
          Service: {
            Type: 'forking',
            Restart: 'always',
            PIDFile: '/var/run/nslcd/nslcd.pid',
            ExecStart: '/usr/sbin/nslcd',
          },
          Install: {
            WantedBy: 'multi-user.target',
          })
  action [:create, :enable]
  triggers_reload true
end

systemd_unit 'nscd.service' do
  content(Unit: {
            Description: 'Name Service Cache Daemon',
            After: 'syslog.target',
          },
          Service: {
            Type: 'forking',
            ExecStart: '/usr/sbin/nscd',
            ExecStop: '/usr/sbin/nscd --shutdown',
            ExecReload: ['/usr/sbin/nscd -i passwd',
                         '/usr/sbin/nscd -i group',
                         '/usr/sbin/nscd -i hosts',
                         '/usr/sbin/nscd -i services',
                         '/usr/sbin/nscd -i netgroup'],
            Restart: 'always',
            PIDFile: '/run/nscd/nscd.pid',
          },
          Install: {
            WantedBy: 'multi-user.target',
            Also: 'nscd.socket',
          })
  action [:create]
  triggers_reload true
end

systemd_unit 'nscd.socket' do
  content(Unit: {
            Description: 'Name Service Cache Daemon Socket',
          },
          Socket: {
            ListenDatagram: '/var/run/nscd/socket',
          },
          Install: {
            WantedBy: 'sockets.target',
          })
  action [:create, :enable]
  triggers_reload true
end
