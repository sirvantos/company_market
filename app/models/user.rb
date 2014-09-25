class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :authorizations, dependent: :destroy, inverse_of: :user

  has_one :authorization, class_name: "Authorization", foreign_key: "user_id", inverse_of: :user
  accepts_nested_attributes_for :authorization

  validates :email,
            length: { maximum: 128, message: "%{count} characters is the maximum allowed" },
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: { case_sensitive: false }

  strip_attributes

  before_create :create_remember_token
  before_save { email.downcase! }

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def add_provider(auth_hash)
    # Check if the provider already exists, so we don't add it twice
    unless auth = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      auth = self.authorizations.create provider: auth_hash["provider"], uid: auth_hash["uid"],
                                        password_digest: Time.at(auth_hash["credentials"]["password_digest"]),
                                        expires_at: Time.at(auth_hash["credentials"]["expires_at"]).to_datetime,
                                        auth_token: auth_hash["credentials"]["token"]
    end

    auth
  end

  def find_provider provider
    Authorization.with_valid_token(provider).for_user(self).first
  end

  def find_application_provider
    find_provider 'application'
  end

  def not_expired_token?(provider)
    find_provider(provider) != nil
  end

  private

  def create_remember_token
    @remember_token = User.digest(User.new_remember_token)
  end
end
