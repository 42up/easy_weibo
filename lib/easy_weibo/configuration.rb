module EasyWeibo
  class Configuration
    attr_accessor :app_key, :app_secret, :redirect_uri

    def initialize
      @app_key = ""
      @app_secret = ""
      @redirect_uri = ""
    end
  end
end
