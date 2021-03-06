require 'httparty'

module CrowdRest
  include HTTParty

  # debug_output $stdout

  autoload :Session, 'crowd_rest/session'
  autoload :User,    'crowd_rest/user'
  autoload :Group,    'crowd_rest/group'
 
  headers 'Content-type' => 'application/json'
  headers 'Accept' => 'application/json'
  
  class << self
    attr_reader :app_name, :app_pass
  end
  
  def self.config
    yield(self)
  end
  
  def self.crowd_url=(url)
    base_uri("#{url}/rest/usermanagement/1")
  end
  
  def self.app_name=(app_name)
    @app_name = app_name
    do_basic_auth if credentials_set?
  end
  
  def self.app_pass=(app_pass)
    @app_pass = app_pass
    do_basic_auth if credentials_set?
  end
  
  private
  
  def self.do_basic_auth
    self.basic_auth(@app_name, @app_pass)
  end
  
  def self.credentials_set?
    @app_name && !@app_name.empty? &&
    @app_pass && !@app_pass.empty?
  end
end
