package 'expect'
package 'ambari-server'

script 'key-destribution' do
  interpreter 'bash'
  code <<-EOH
    echo | echo | echo | ssh-keygen
    ssh-keyscan 10.0.0.10 >> /home/vagrant/.ssh/known_hosts
    ssh-keyscan 10.0.0.11 >> /home/vagrant/.ssh/known_hosts
    ssh-keyscan 10.0.0.12 >> /home/vagrant/.ssh/known_hosts
    ssh-keyscan 10.0.0.14 >> /home/vagrant/.ssh/known_hosts
    hosts=( 10.0.0.10 10.0.0.11 10.0.0.12 10.0.0.14 )
    cat > /home/vagrant/keys.sh <<-'EOF'
#!/usr/bin/expect -f

if { $argc != 4 } {
    puts stderr "usage: ./keys.sh host pass user keyfile"
  exit 2
}

set host [lindex $argv 0]
set pass [lindex $argv 1]
set user [lindex $argv 2]
set keyfile [lindex $argv 3]

spawn ssh-copy-id -i $keyfile $user@$host
expect "assword:"
send "$pass\n"
expect eof
EOF
  chmod +x /home/vagrant/keys.sh
  for host in "${hosts[@]}" ; do ./home/vagrant/keys.sh "$host" vagrant vagrant /home/vagrant/.ssh/id_rsa.pub ; done
  EOH
end

bash 'ambari-server-setup' do
  code '/usr/sbin/ambari-server setup -j /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.77-0.b03.el7_2.x86_64/jre/'
  action :run
end

execute 'ambari-server-start' do
  command 'ambari-server start'
end
