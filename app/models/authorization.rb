class Authorization < ActiveRecord::Base
  belongs_to :user, inverse_of: :authorizations

  strip_attributes
  has_secure_password

  validates :provider, length: { maximum: 254}
  validates :uid, uniqueness: { case_sensitive: false, scope: [:provider], allow_nil: true },
            length: { maximum: 254}
  validates :password, length: { minimum: 6 }, allow_nil: true

  scope :with_valid_token, ->(provider) { where("(expires_at is null or expires_at > NOW()) AND provider = ?", provider) }
  scope :for_user, ->(user) { where("user_id = ?", user) }

  before_save do
   if provider.blank?
     self.provider = 'application'
   end
   if uid.blank?
     self.uid = user.id
   end
  end

  def self.find_or_create(auth_hash, user)
    unless auth = find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      unless user then
        raw_info = auth_hash["info"]
        user = User.create email: raw_info["email"]
      end
      auth = user.add_provider auth_hash
    else
      unless auth_hash["credentials"].blank?
        auth.update_attributes(
            expires_at: Time.at(auth_hash["credentials"]["expires_at"]).to_datetime,
            auth_token: auth_hash["credentials"]["token"]
        )
      end
    end

    auth
  end
end
