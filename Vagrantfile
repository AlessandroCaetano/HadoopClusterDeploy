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
    ambari.vm.provider "virtualbox" do |vm, override|
      override.vm.network 'private_network', ip: ips['ambari'] if ips
    end
  end
end
