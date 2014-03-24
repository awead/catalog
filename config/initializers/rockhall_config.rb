RH_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/rockhall.yml")[Rails.env]

# setup up empty hash to put our configuration into
config = Hash.new

# IP of our OPAC
config[:opac_ip] = RH_CONFIG['opac_ip']

# Path to ead xml
config[:ead_path] = RH_CONFIG['ead_path']

# Path to our streaming server
config[:rtmp_url] = RH_CONFIG['rtmp_url']

# Local networks
config[:local_networks] = RH_CONFIG['local_networks']

# Maximum number of components to return before "more" link
config[:max_components] = RH_CONFIG['max_components']

# Pin our hash to the global Rails configuration
Rails.configuration.rockhall_config = config