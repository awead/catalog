# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_blacklight-app_session',
  :secret      => '5d5a47207cef6c4d5dd98ad5265900458427fc9b63235e78ba780bd2eeb883d90e727e79e968b7faf61f69f5d17a5a4dfc696bd1b6ac6ddb154d3d535e060a84'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
