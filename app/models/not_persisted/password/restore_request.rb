  class NotPersisted::Password::RestoreRequest < NotPersisted::Base
    attr_accessor :auth_id, :hash

    validates :hash, presence: true, Md5Hash: true
    validates :auth_id, presence: true
  end
