resource_name :kafka_manager
property :repo, String, default: 'spuder/kafka-manager'
property :package_version, String, default: '1.2.7' #1.2.8 and newer don't scale well with large clusters https://github.com/yahoo/kafka-manager/issues/162

action :install do

  # Create a service user since the .deb file requires it
  user 'kafka-manager' do
    comment 'kafka-manager'
    shell '/bin/false'
    action :create
  end

  case node['platform_family']
  when 'rhel'
    repo_type = 'rpm'
  when 'debian'
    repo_type = 'deb'
  else
    Chef::Log.fatal("Only supports ubuntu / centos. Found: #{node['platform_family']}")
  end

  packagecloud_repo "#{repo}" do
    type "#{repo_type}"
    action :add
  end

  package 'kafka-manager' do
    version "#{package_version}"
    action :install
  end

  # Work around issue https://github.com/yahoo/kafka-manager/issues/13#issuecomment-160996849
  case node['platform_family']
  when 'rhel'
    #TODO Add support for centos init scripts
  when 'debian'
    cookbook_file '/etc/init/kafka-manager.conf' do
      source 'upstart/kafka-manager.conf'
      owner 'root'
      group 'root'
      mode 00644
      action :create
    end
  else
    Chef::Log.fatal("Only supports ubuntu / centos. Found: #{node['platform_family']}")
  end


  # chown the kafka-manager folder so the kafka-manager can use it
  execute 'chown kafka-manager' do
    command 'chown -R kafka-manager:kafka-manager /usr/share/kafka-manager'
    user "root"
    action :run
    not_if "stat -c %U /usr/share/kafka-manager/README.md | grep kafka-manager"
  end

  # chown the kafka-manager log directory since package chowns to root
  execute 'chown kafka-manager log directory' do
    command 'chown -R kafka-manager:kafka-manager /var/log/kafka-manager'
    user "root"
    action :run
    not_if "stat -c %U /var/log/kafka-manager | grep kafka-manager"
  end

end
