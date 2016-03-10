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



