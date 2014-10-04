  class NotPersisted::Password::Restore < NotPersisted::Base
    attr_accessor :email

    validates :email,
              length: { maximum: 128, message: "%{count} characters is the maximum allowed" },
              presence: true,
              email: true
  end
