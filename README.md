# EasyWeibo

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/easy_weibo`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'easy_weibo'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install easy_weibo

## Usage
```
EasyWeibo.configure do |config|
  config.app_key = ""
  config.app_secret = ""
  config.redirect_uri = "https://api.weibo.com/oauth2/default.html"
end

@client = EasyWeibo::Client.new
puts @client.authorize_url
@client.code = "code"
@client.token = "token"
@client.statuses_share("foobar", "https://web.com", "#{EasyWeibo.root}/test.jpg")
```

## Todo
+ 异常处理

```
# {"error":"invalid_grant","error_code":21325,"request":"/oauth2/access_token","error_uri":"/oauth2/access_token","error_description":"invalid authorization code:"}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/easy_weibo.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
