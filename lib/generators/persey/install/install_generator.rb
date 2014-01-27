module Persey
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def create_configuration
        copy_file("config.rb", "config/config.rb")
      end

    end
  end
end
