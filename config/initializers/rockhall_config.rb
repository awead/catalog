# setup up empty hash to put our configuration into
config = Hash.new

# IP of our OPAC
config[:opac_ip] = "129.22.104.30"

# Path to ead xml
config[:ead_path] = "public/fa"

# Path to our streaming server
config[:rtmp_url] = "rtmp://192.168.251.84/vod"

# Pin our hash to the global Rails configuration
Rails.configuration.rockhall_config = config