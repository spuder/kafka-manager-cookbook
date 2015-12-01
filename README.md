# kafka-manager


![](https://img.shields.io/cookbook/v/kafka-manager.svg)
![](https://img.shields.io/github/tag/spuder/kafka-manager-cookbook.svg)

Installs java and downloads kafka-manager from package cloud
Note, these are **unofficial packages**. Follow [this github issue for the status of official packages.](https://github.com/yahoo/kafka-manager/issues/18)

The packages are currently only available for ubuntu, centos images will be created if needed

[spuder/kafka-manager](https://packagecloud.io/spuder/kafka-manager)

**Warning** kafka-manager 1.2.8 and newer [don't work well with large clusters](https://github.com/yahoo/kafka-manager/issues/162). The default is version 1.2.7

# Supports

- Ubuntu 14.04
- Centos (Untested)


# Usage

This cookbook uses custom resources so **chef 12.5 or newer is required**. The cookbook can be used in 2 ways

1. As a community cookbook

Create a role and add `java` and `kafka-manager` to your run_list

```json
{
  "run_list": [
    "recipe[apt]",
    "recipe[java]",
    "recipe[kafka-manager]"
  ],
  "default_attributes": {
    "kafka-manager":{
      "zkhosts": "foo:2181,bar:2181",
      "version": "1.2.7"
    }
  }
}
```

2. As a library cookbook

Create a wrapper cookbook and call the custom resources directly


```ruby

kafka_manager 'default' do
  repo 'spuder/kafka-manager'
  package_version '1.2.7'
  action :install
end

template '/usr/share/kafka-manager/conf/application.conf' do
  source 'application.conf.erb'
  variables ({
    :zkhosts => "#{node['kafka-manager']['zkhosts']}"
  })
  notifies :restart, 'service[kafka-manager]'
end

service 'kafka-manager' do
  action [ :enable, :start ]
end
```
If using a wrapper cookbook, you could use search to automatically fetch the zookeeper hosts from the chef server


By default kafka-manager runs on port 9000. You may want to setup a reverse proxy to redirect requests from port 80
A recipe and a custom resource are provided that will install nginx and setup the redirect.

In your role

```json
"run_list": [
  "recipe[apt]",
  "recipe[java]",
  "recipe[kafka-manager]"
  "recipe[kafka-manager::nginx]"
]
```

Or in your wrapper cookbook

```ruby
kafka_proxy 'default' do
  action :create
end
```

# Attributes

Change the value of 'zkhosts' to the zookeeper servers

     node['kafka-manager']['zkhosts']= 'foo:2181,bar:2181'


kafka-manager-cookbook is not affiliated with Yahoo or the creators of kafka-manager.
