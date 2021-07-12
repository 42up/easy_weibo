# frozen_string_literal: true

require_relative "easy_weibo/version"
require "easy_weibo/client"
require "easy_weibo/configuration"

require "httpx"

module EasyWeibo
  class Error < StandardError; end

  def self.configuration
    @configuration ||= Configuration.new
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def app_key
      configuration.app_key
    end

    def app_secret
      configuration.app_secret
    end

    def redirect_uri
      configuration.redirect_uri
    end

    def root
      File.dirname __dir__
    end
  end
end
