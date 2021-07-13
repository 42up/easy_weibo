module EasyWeibo
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "EasyWeibo installation: initializer"
      source_root File.expand_path("../../templates", __FILE__)

      def install
        puts "==> generate initializer file ..."
        copy_initializer
        puts "Done!"
      end

      private

      def copy_initializer
        template "initializer.rb", "config/initializers/easy_weibo.rb"
      end
    end
  end
end
