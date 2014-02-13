class OpdsService < ActiveRecord::Base
  attr_accessible :login, :password, :url
  attr_encrypted :password, :key => ENCRYPTED_KEY

  def sync_opds
  	client=Curl::Easy.new
    client.headers["User-Agent"] = "OpdsServer"
    client.verbose = defined?(Rails) && !Rails.env.production?
    unless self.login.blank? || self.password.blank?
    	client.username = self.login
    	client.password = self.password
    end
    client.enable_cookies = true
    client.encoding="deflate, gzip"
    client.url = self.url
    ret = client.http_get()

  end

end
