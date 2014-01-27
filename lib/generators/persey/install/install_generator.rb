module Persey
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def create_configuration
        copy_file("config.rb", "config/config.rb")
        inject_into_file 'config/application.rb', before: "module #{Rails.application.class.parent_name}" do
          <<-'RUBY'
require "persey"
require File.expand_path('../config', __FILE__)

          RUBY
        end
      end

      def ignore_configuration
        if File.exists?("config/config.rb")
          append_to_file("config/config.rb") do
            <<-EOF.strip_heredoc

              # Define method in #{Rails.application.class.parent_name}
              module #{Rails.application.class.parent_name}
                def self.config
                  Persey.config
                end
              end
              EOF
          end
        end
      end
    end
  end
end
