default['kafka-manager']['version'] = '1.2.7' #1.2.8 and newer don't scale well with large clusters https://github.com/yahoo/kafka-manager/issues/162
default['kafka-manager']['zkhosts'] = 'kafka-manager-zookeeper:2181' #comma separated, no spaces
