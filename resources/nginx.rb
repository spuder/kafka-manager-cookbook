resource_name :kafka_proxy

action :create do

  # While you could use a nginx cookbook to do this, it would be too complicated
  package 'nginx' do
    action :install
  end

  template '/etc/nginx/sites-available/kafka-manager' do
    source 'nginx.erb'
    notifies :restart, 'service[nginx]'
  end

  link '/etc/nginx/sites-enabled/kafka-manager' do
    to '/etc/nginx/sites-available/kafka-manager'
    notifies :restart, 'service[nginx]'
  end

  file '/etc/nginx/sites-enabled/default' do
    action :delete
    notifies :restart, 'service[nginx]'
  end

  service 'nginx' do
    action [ :enable, :start ]
  end


end
