require 'rails/generators/base'
require 'rails/generators/active_record'

module Clearance
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def create_clearance_initializer
        copy_file 'clearance.rb', 'config/initializers/clearance.rb'
      end

      def inject_clearance_into_application_controller
        inject_into(
          ApplicationController,
          'app/controllers/application_controller.rb',
          'include Clearance::Controller'
        )
      end

      def create_or_inject_clearance_into_user_model
        if File.exists? 'app/models/user.rb'
          inject_into_file(
            'app/models/user.rb',
            "include Clearance::User\n\n",
            after: "class User\n
                    include Mongoid::Document\n
                    include Mongoid::Timestamps\n\n
                    validates_presence_of :email, :encrypted_password, :remember_token\n
                    validates_length_of :encrypted_password, :confirmation_token, :remember_token, maximum: 128\n\n
                    field :email, type: String\n
                    field :encrypted_password, type: String\n
                    field :confirmation_token, type: String\n
                    field :remember_token, type: String\n
                    index\(\{ email: 1 \}, \{ unique: true, name: \"email_index\" \}\)\n
                    index\(\{ remember_token: 1 \}, \{ unique: true, name: \"remember_token_index\" \}\)\n"
          )
        else
          copy_file 'user.rb', 'app/models/user.rb'
        end
      end

      def create_clearance_migration
        
      end

      def display_readme_in_terminal
        readme 'README'
      end

      private

      def create_add_columns_migration
        
      end

      def copy_migration(migration_name, config = {})
        
      end

      def inject_into(class_name, file, text)
        if file_does_not_contain?(file, text)
          inject_into_class file, class_name, "  #{text}\n"
        end
      end

      def file_does_not_contain?(file, text)
        File.readlines(file).grep(/#{text}/).none?
      end

      def migration_needed?
        
      end

      def new_columns
      
      end

      def new_indexes
     
      end

      def migration_exists?(name)
        
      end

      def existing_migrations
        
      end

      def migration_name_without_timestamp(file)
        
      end

      def users_table_exists?
        
      end

      def existing_users_columns
        
      end

      def existing_users_indexes
        
      end

      # for generating a timestamp when using `create_migration`
      def self.next_migration_number(dir)
        
      end
    end
  end
end
