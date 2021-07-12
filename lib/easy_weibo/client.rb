require "httpx"
require "http/form_data"
require "json"
require "active_support"

module EasyWeibo
  class Client
    OAUTH2_AUTHORIZE_URL = "https://api.weibo.com/oauth2/authorize"
    OAUTH2_ACCESS_TOKEN_URL = "https://api.weibo.com/oauth2/access_token"
    STATUSES_SHARE_URL = "https://api.weibo.com/2/statuses/share.json"

    attr_writer :token, :code

    def initialize
      @code = nil
      @token = nil
    end

    # 构造授权地址，获取code
    # https://open.weibo.com/wiki/Oauth2/authorize
    def authorize_url
      "#{OAUTH2_AUTHORIZE_URL}?redirect_uri=#{EasyWeibo.redirect_uri}&client_id=#{EasyWeibo.app_key}&display=wap"
    end

    # 获取token
    # https://open.weibo.com/wiki/Oauth2/access_token
    def access_token
      raise "code is nil" if @code.blank?

      payload = {
        client_id: EasyWeibo.app_key,
        client_secret: EasyWeibo.app_secret,
        grant_type: "authorization_code",
        code: @code,
        redirect_uri: EasyWeibo.redirect_uri,
      }

      resp = HTTPX.post(OAUTH2_ACCESS_TOKEN_URL, params: payload)

      r = ::JSON.parse(resp.body, quirks_mode: true)
      yield r if block_given?
      r
    end

    # 获取access_token
    def token
      @token ||= access_token["access_token"]
    end

    # 发布微博
    def statuses_share(text, url, pic = nil)
      # TODO: 抛出异常 必须做URLencode，内容不超过140个汉字
      status = "#{text} #{url}"

      payload = { status: status }
      payload[:pic] = pic.is_a?(String) ? HTTP::FormData::File.new(pic) : pic unless pic.blank?

      resp = HTTPX.plugin(:multipart).post(STATUSES_SHARE_URL, params: { access_token: token }, form: payload)

      r = ::JSON.parse(resp.body, quirks_mode: true)
      yield r if block_given?
      r
    end
  end
end
