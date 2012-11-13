# Global settings for ActionMailer

ActionMailer::Base.smtp_settings = {
  :address => "192.168.250.174",
  :port    => 25,
  :domain  => 'rockhall.org',
}

ActionMailer::Base.default :from => 'library@rockhall.org'