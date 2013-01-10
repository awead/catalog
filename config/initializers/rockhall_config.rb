# setup up empty hash to put our configuration into
config = Hash.new

# IP of our OPAC
config[:opac_ip] = "129.22.104.30"

# Path to ead xml
config[:ead_path] = "public/fa"

# Pin our hash to the global Rails configuration
Rails.configuration.rockhall_config = config