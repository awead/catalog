# setup up empty hash to put our configuration into
config = Hash.new

# IP of our OPAC
config[:opac_ip] = "129.22.104.30"

# Path to ead xml
config[:ead_path] = "spec/fixtures/ead"

# When indexing in production, send html, json and xml files to a remote server
# Executes an rsync command, requires and ssh key to work with the username you supply
config[:ead_remote_path] = "~/fa"
config[:ead_remote_host] = "george.rockhall.org"
config[:ead_remote_user] = "adamw"

# Pin our hash to the global Rails configuration
Rails.configuration.rockhall_config = config
