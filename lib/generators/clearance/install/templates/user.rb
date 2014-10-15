class User 
	include Mongoid::Document
  include Mongoid::Timestamps
  include Clearance::User

  validates_presence_of :email, :encrypted_password, :remember_token
  validates_length_of :encrypted_password, :confirmation_token, :remember_token, maximum: 128
  field :email, type: String
  field :encrypted_password, type: String
  field :confirmation_token, type: String
  field :remember_token, type: String
  index({ email: 1 }, { unique: true, name: "email_index" })
  index({ remember_token: 1 }, { unique: true, name: "remember_token_index" })
end
