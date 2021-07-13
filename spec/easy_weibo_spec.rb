# frozen_string_literal: true
require "pry"

RSpec.describe EasyWeibo do
  it "has a version number" do
    expect(EasyWeibo::VERSION).not_to be nil
  end

  describe "a specification" do
    before do
      @app_key = "test_app_key"
      @app_secret = "test_app_secret"
      EasyWeibo.configure do |config|
        config.app_key = @app_key
        config.app_secret = @app_secret
        config.redirect_uri = "https://api.weibo.com/oauth2/default.html"
      end

      @client = EasyWeibo::Client.new
      @client.token = "token"
    end

    it "authorize_url" do
      url = @client.authorize_url
      puts url
      expect(url.include?("wap")).to be true
      expect(url.include?(@app_key)).to be true
    end

    it "user timeline" do
      @client.user_timeline "2715025067"
    end
  end
end
