# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_blacklight-app_session',
  :secret      => 'eb9217b5c421370589d36b27e1bc37f451e82ad7d38136b0c70f9d9c90bf6773ee54e56c2960544845c956ab4f2df8c72ca08ada2463bd48c6ba334cf0fb7ae8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
