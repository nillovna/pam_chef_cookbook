execute 'disable_selinux' do
  command 'setenforce 0'
  only_if 'getenforce | grep Enforcing'
end

ruby_block 'replace_line_selinux' do
  block do
    file = Chef::Util::FileEdit.new('/etc/selinux/config')
    file.search_file_replace_line(/SELINUX=.*/, 'SELINUX=disabled')
    file.write_file
  end
  only_if { File.exist?('/etc/selinux/config') }
end
