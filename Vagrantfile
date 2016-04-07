# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
VAGRANTFILE_API_VERSION = "2"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true
  config.ssh.forward_agent = true 
  config.ssh.insert_key = true
  config.vm.provision "shell" do |s|
    ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip
    s.inline = <<-SHELL
      echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
    SHELL
  end
  
  $install_necessary_packages = <<-SCRIPT
  yum install -y  expect
  SCRIPT
  
  $key_distribution = <<-SCRIPT
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
  for host in "${hosts[@]}" ; do ./keys.sh "$host" vagrant vagrant /home/vagrant/.ssh/id_rsa.pub ; done
  SCRIPT

  if File.exist?("config/ips.yaml")
    ips = YAML.load_file("config/ips.yaml")
  else
    ips = nil
  end

  config.vm.define 'metrics' do |metrics|
    metrics.vm.hostname = 'metrics'
    metrics.vm.provider "virtualbox" do |vm, override|
      override.vm.network 'private_network', ip: ips['metrics'] if ips
    end
  end

  config.vm.define 'spark' do |spark|
    spark.vm.hostname = 'spark'
    spark.vm.provider "virtualbox" do |vm, override|
      override.vm.network 'private_network', ip: ips['spark'] if ips
    end
  end

  config.vm.define 'hive' do |hive|
    hive.vm.hostname = 'hive'
    hive.vm.provider "virtualbox" do |vm, override|
      override.vm.network 'private_network', ip: ips['hive'] if ips
    end
  end

  config.vm.define 'hbase' do |hbase|
    hbase.vm.hostname = 'hbase'
    hbase.vm.provider "virtualbox" do |vm, override|
      override.vm.network 'private_network', ip: ips['hbase'] if ips
    end
  end

  config.vm.define 'ambari' do |ambari|
    ambari.vm.hostname = 'ambari'
    #I need passwordless ssh between vms, so here all ips have to be hardcoded
    ambari.vm.provision "shell", inline: $install_necessary_packages, privileged: true
    ambari.vm.provision "shell", inline: $key_distribution, privileged: false
    ambari.vm.provider "virtualbox" do |vm, override|
      override.vm.network 'private_network', ip: ips['ambari'] if ips
    end
  end
end
