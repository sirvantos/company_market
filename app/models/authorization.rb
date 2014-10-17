class Authorization < ActiveRecord::Base
  RESTORE_HASH_LIFETIME_iN_MIN = 60

  belongs_to :user, inverse_of: :authorizations

  strip_attributes allow_empty: true, except: [:password_digest, :confirmation_hash, :restore_password_hash, :auth_token]
  has_secure_password(validations: false)

  validates :provider, length: { maximum: 254}
  validates :uid, uniqueness: { case_sensitive: false, scope: [:provider], allow_nil: true },
            length: { maximum: 254}
  validates :password, length: { minimum: 6 }, unless: Proc.new { |a| a.password_confirmation.nil? }
  validates_confirmation_of :password, if: ->{ password.present? }

  scope :with_valid_token, ->(provider) { where("(expires_at is null or expires_at > NOW()) AND provider = ?", provider) }
  scope :for_user, ->(user) { where("user_id = ?", user) }

  before_create :create_base_state
  after_create :send_mail_confirmation

  def self.find_to_password_restore(params)
    where(
        'id = :id and restore_password_hash = :rph and EXTRACT(EPOCH FROM NOW() - "restore_password_hash_created") <= :life_time',
        id: params[:id], rph: params[:rph], life_time: RESTORE_HASH_LIFETIME_iN_MIN * 60
    ).first
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

  def is_application_provider?
    self.provider == 'application'
  end

  def confirmed?
    return true unless is_application_provider?

    self.confirmation_hash.nil?
  end

  def generate_md5_hash
    Digest::MD5.hexdigest(SecureRandom.urlsafe_base64.to_s)
  end

  private

  def create_base_state
    unless uid
      self.uid = user.id
    end

    unless provider
      self.provider = 'application'
    end

    if is_application_provider?
      create_confirmation_hash
    end
  end

  def create_confirmation_hash
    self.confirmation_hash = generate_md5_hash
  end

  def send_mail_confirmation
    Resque.enqueue(MailWorker, for: 'account_confirmation', auth_id: self.id)
  end
end
