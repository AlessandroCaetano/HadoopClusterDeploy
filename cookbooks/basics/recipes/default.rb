package 'openssh-server'
package 'epel-release'
package 'vim'
package 'bash-completion'
package 'rsyslog'
package 'tmux'
package 'less'
package 'htop'
package 'ntp'
package 'screen'
package 'wget'
package 'curl'
package 'java-1.8.0-openjdk'

cookbook_file '/usr/local/bin/is-a-container' do
  owner 'root'
  group 'root'
  mode 0755
end

service 'ntpd' do
  action [:enable, :start]
  not_if 'is-a-container'
end

service 'firewalld' do
  action [:disable, :stop]
  ignore_failure true
end

service 'sshd' do
  action [:enable]
end

cookbook_file '/etc/yum.repos.d/ambari.repo' do
  owner 'root'
  group 'root'
  mode 0644
end

cookbook_file '/etc/yum.repos.d/hdp.repo' do
  owner 'root'
  group 'root'
  mode 0644
end

execute 'update-repos' do
  command 'yum makecache'
end

package 'snappy-devel'

cookbook_file '/etc/sysconfig/selinux' do
  owner 'root'
  group 'root'
  mode 0644
end

execute 'setenforce Permissive' do
  command 'setenforce 0'
end
