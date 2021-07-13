require "httpx"
require "http/form_data"
require "json"
require "active_support"

module EasyWeibo
  class Client
    OAUTH2_AUTHORIZE_URL = "https://api.weibo.com/oauth2/authorize"
    OAUTH2_ACCESS_TOKEN_URL = "https://api.weibo.com/oauth2/access_token"
    STATUSES_SHARE_URL = "https://api.weibo.com/2/statuses/share.json"
    USER_TIMELINE_URL = "https://api.weibo.com/2/statuses/user_timeline.json"
    USERS_SHOW_URL = "https://api.weibo.com/2/users/show.json"

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

    # https://open.weibo.com/wiki/2/statuses/user_timeline
    def user_timeline(uid, options = {})
      params = {
        access_token: token,
        uid: uid,
        since_id: options.delete(:since_id) || 0, # 若指定此参数，则返回ID比since_id大的微博（即比时间晚的微博），默认为0。
        max_id: options.delete(:max_id) || 0, # 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        count: options.delete(:count) || 20, # 单页返回的记录条数，最大不超过100，超过100以100处理，默认为20。
        page: options.delete(:page) || 1, # 返回结果的页码，默认为1。
        base_app: options.delete(:base_app) || 0, # 是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
        feature: options.delete(:feature) || 0, # 过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
        trim_user: options.delete(:trim_user) || 0, # 返回值中user字段开关，0：返回完整user字段、1：user字段仅返回user_id，默认为0。
      }

      resp = HTTPX.get(USER_TIMELINE_URL, params: params)

      r = ::JSON.parse(resp.body, quirks_mode: true)
      yield r if block_given?
      r
    end

    def users_show(uid)
      params = { uid: uid, access_token: token }

      resp = HTTPX.get(USERS_SHOW_URL, params: params)

      r = ::JSON.parse(resp.body, quirks_mode: true)
      yield r if block_given?
      r
    end
  end
end
