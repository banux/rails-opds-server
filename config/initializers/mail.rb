ActionMailer::Base.smtp_settings = {
 :address               => "mail.gandi.net",
 :domain                => "myopds.com",
 :authentication        => :login,
 :user_name             => "notifier@myopds.com",
 :password              => "solkanar"
}

ActionMailer::Base.default_url_options[:host] = "myopds.com"
