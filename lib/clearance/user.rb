require 'digest/sha1'
require 'email_validator'
require 'clearance/token'

module Clearance
  module User
    extend ActiveSupport::Concern

    included do
      attr_accessor :password_changing
      attr_reader :password

      include Validations
      include Callbacks
      include password_strategy
    end

    module ClassMethods
      def authenticate(email, password)
        if user = find_by_normalized_email(email)
          if password.present? && user.authenticated?(password)
            return user
          end
        end
      end

      def find_by_normalized_email(email)
        self.find_by(email: "normalize_email(email)").first
      end

      def normalize_email(email)
        email.to_s.downcase.gsub(/\s+/, "")
      end

      private

      def password_strategy
        Clearance.configuration.password_strategy || PasswordStrategies::BCrypt
      end
    end

    module Validations
      extend ActiveSupport::Concern

      included do
        validates_uniqueness_of :email
        validates_presence_of :email, :encrypted_password, :remember_token
        validates_length_of :encrypted_password, :confirmation_token, :remember_token, maximum: 128
        validates_presence_of :password, unless: :skip_password_validation?
      end
    end

    module Callbacks
      extend ActiveSupport::Concern

      included do
        before_validation :normalize_email
        before_create :generate_remember_token
      end
    end

    def forgot_password!
      generate_confirmation_token
      save validate: false
    end

    def reset_remember_token!
      generate_remember_token
      save validate: false
    end

    def update_password(new_password)
      self.password_changing = true
      self.password = new_password

      if valid?
        self.confirmation_token = nil
        generate_remember_token
      end

      save
    end

    private

    def normalize_email
      self.email = self.class.normalize_email(email)
    end

    def email_optional?
      false
    end

    def password_optional?
      false
    end

    def skip_password_validation?
      password_optional? || (encrypted_password.present? && !password_changing)
    end

    def generate_confirmation_token
      self.confirmation_token = Clearance::Token.new
    end

    def generate_remember_token
      self.remember_token = Clearance::Token.new
    end
  end
end
