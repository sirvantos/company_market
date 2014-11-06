class AuthorizationController < ApplicationController
  before_action :check_restore_hash, only: [:restore_password]

  def confirm
    auth = Authorization.find_by(id: params[:id], confirmation_hash: params[:hash].downcase)
    if auth
      auth.update_attribute(:confirmation_hash, nil)
      sign_in auth.user

      redirect_to root_path, :flash => { :success => "Hello, we have activated your account!" }
    else
      redirect_to root_path, danger: "Sorry, wrong confirmation hash!"
    end
  end

  def restore_password
    if request.patch?
      if @auth.update_attributes(restore_password_params)
        @auth.update_columns(restore_password_hash: nil, restore_password_hash_created: nil)

        redirect_to root_path, :flash => { :success => "Your password has been changed" }
      end
    end
  end

  def restore_password_email
    if request.post?
      @restore_password = NotPersisted::Password::Restore.new(restore_password_email_params)
      if @restore_password.valid?
        user = User.find_by_email(@restore_password.email)
        unless user.nil?
          app_provider = user.find_application_provider
          unless app_provider.nil? || !app_provider.confirmed?
            Resque.enqueue(MailWorker, for: 'password_restore', auth_id: app_provider.id)

            redirect_to root_path, :flash => { :success => "We have sent restore password instruction to your mail!" }
            return
          end
        end

        @restore_password.errors.add(:email, "doesn't exist")
      end
    else
      @restore_password = NotPersisted::Password::Restore.new()
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def restore_password_email_params
    params.require(:not_persisted_password_restore).permit(:email)
  end

  def restore_password_params
    params.require(:authorization).permit(:password, :password_confirmation)
  end

  def check_restore_hash
    restoreRequest = NotPersisted::Password::RestoreRequest.new(auth_id: request.params[:id], hash: request.params[:hash])
    if restoreRequest.valid?
      @auth = Authorization.find_to_password_restore(id: restoreRequest.auth_id, rph: restoreRequest.hash)
      return unless @auth.nil?
    end

    redirect_to root_path, danger: "Wrong restore request format"
  end
end