# # encoding: utf-8

# Inspec test for recipe pam_chef_cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

#---
# Get node object
#---

require 'json'

cookbook = 'pam'
nodes_dir = '/tmp/kitchen/nodes'
kitchen_node = command("ls #{nodes_dir}").stdout.strip
node_json = "#{nodes_dir}/#{kitchen_node}"

node = json(node_json).params

node_attr = if node['normal'][cookbook].nil?
              node['default'][cookbook]
            else
              node['default'][cookbook].merge(node['normal'][cookbook])
            end

nslcd = node_attr['nslcd']
nscd = node_attr['nscd']
list_pkg = node_attr['list_pkg']

#---
# Run tests
#---

if os.family == 'debian' || os.family == 'redhat'
  pam_dir = '/etc/pam.d'

  list_pkg.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  if os.family == 'debian'

    %w(sshd).each do |cfg|
      describe file("#{pam_dir}/#{cfg}") do
        it { should exist }
        it { should be_file }
        its('mode') { should cmp '0644' }
        its('owner') { should eq 'root' }
        its('group') { should eq 'root' }
        its('content') { should match(%r{session[ \t]+?required[ \t]+?pam_mkhomedir.so[ \t]+?skel=/etc/skel umask=0022}) }
      end
    end

  elsif os.family == 'redhat'

    describe command('getenforce') do
      its('stdout') { should_not eq "Enforcing\n" }
      its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end

    describe file('/etc/selinux/config') do
      it { should exist }
      its('content') { should match(/^SELINUX=disabled$/) }
    end

    %w(system-auth-ac password-auth-ac).each do |cfg|
      describe file("#{pam_dir}/#{cfg}") do
        it { should exist }
        it { should be_file }
        its('mode') { should cmp '0644' }
        its('owner') { should eq 'root' }
        its('group') { should eq 'root' }
        its('content') { should match(/auth[ \t]+?sufficient[ \t]+?pam_ldap.so[ \t]+?use_first_pass/) }
        its('content') { should match(/account[ \t]+?required[ \t]+?pam_unix.so[ \t]+?broken_shadow/) }
        its('content') { should match(/account[ \t]+?\[default=bad success=ok user_unknown=ignore\][ \t]+?pam_ldap.so/) }
        its('content') { should match(/password[ \t]+?sufficient[ \t]+?pam_ldap.so[ \t]+?use_authtok/) }
        its('content') { should match(/session[ \t]+?optional[ \t]+?pam_mkhomedir.so[ \t]+?umask=0077/) }
        its('content') { should match(/session[ \t]+?optional[ \t]+?pam_ldap.so/) }
      end
    end

    %w(fingerprint-auth-ac smartcard-auth-ac).each do |cfg|
      describe file("#{pam_dir}/#{cfg}") do
        it { should exist }
        it { should be_file }
        its('mode') { should cmp '0644' }
        its('owner') { should eq 'root' }
        its('group') { should eq 'root' }
        its('content') { should match(/account[ \t]+?required[ \t]+?pam_unix.so[ \t]+?broken_shadow/) }
        its('content') { should match(/account[ \t]+?\[default=bad success=ok user_unknown=ignore\][ \t]+?pam_ldap.so/) }
        its('content') { should match(/session[ \t]+?optional[ \t]+?pam_mkhomedir.so[ \t]+?umask=0077/) }
        its('content') { should match(/session[ \t]+?optional[ \t]+?pam_ldap.so/) }
      end
    end

    nslcd['ldapservers'].each do |srv|
      describe file('/etc/openldap/ldap.conf') do
        it { should exist }
        it { should be_file }
        its('mode') { should cmp '0644' }
        its('owner') { should eq 'root' }
        its('group') { should eq 'root' }
        its('content') { should match(/URI\s.*?#{srv}/) }
        its('content') { should match(/BASE[ \t]+?#{nslcd['base']}/) }
        its('content') { should match(/SASL_NOCANON[ \t]+?#{nslcd['sasl_nocanon']}/) }
      end
    end
  end

  describe file('/etc/nscd.conf') do
    it { should exist }
    it { should be_file }
    its('mode') { should cmp '0644' }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('content') { should match(/persistent[ \t]+?passwd[ \t]+?no/) }
    its('content') { should match(/persistent[ \t]+?group[ \t]+?no/) }
    its('content') { should match(/positive-time-to-live[ \t]+?group[ \t]+?#{nscd['cache_names']['group']['positive-time-to-live']}/) }
    its('content') { should match(/enable-cache[ \t]+?netgroup[ \t]+?#{nscd['cache_names']['netgroup']['enable-cache']}/) }
  end

  describe file('/etc/nsswitch.conf') do
    it { should exist }
    it { should be_file }
    its('mode') { should cmp '0644' }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('content') { should match(/passwd:.*?ldap/) }
    its('content') { should match(/group:.*?ldap/) }
  end

  nslcd['ldapservers'].each do |srv|
    describe file('/etc/nslcd.conf') do
      it { should exist }
      it { should be_file }
      its('mode') { should cmp '0640' }
      its('owner') { should eq 'root' }
      its('group') { should eq 'root' }
      its('content') { should match(/^uid[ \t]+?#{nslcd['uid']}/) }
      its('content') { should match(/^gid[ \t]+?#{nslcd['gid']}/) }
      its('content') { should match(/^uri[ \t]+?#{srv}/) }
      its('content') { should match(/^base[ \t]+?#{nslcd['base']}/) }
      its('content') { should match(/^binddn[ \t]+?#{nslcd['binddn']}/) }
      its('content') { should match(/^bindpw[ \t]+?#{nslcd['bindpw']}/) }
    end
  end

  %w(nscd nslcd).each do |svc|
    describe systemd_service(svc) do
      it { should be_enabled }
      it { should be_installed }
      it { should be_running }
    end
  end

# Use any user from ldap which doesn't exist in system
  ldap_user = 'infra_deploy'
  describe command("id #{ldap_user}") do
    its('stderr') { should eq '' }
    its('exit_status') { should eq 0 }
  end
end
