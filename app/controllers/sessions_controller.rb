class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']

    if auth_hash.blank?
      local_strategy
    else
      remote_strategy auth_hash
    end
  end

  def failure
    flash[:danger] = "Sorry, but you didn't allow access to our app!"
    render nothing: true
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  private

  def remote_strategy auth_hash
    auth = Authorization.find_or_create auth_hash, current_user

    unless signed_in? then
      sign_in auth.user
    end

    flash[:success] = "Welcome " + auth.user.name + " to the facebook activity"
    redirect_to back_url
  end

  def local_strategy
    user = User.find_by(email: params[:email].downcase)
    if(user)
      provider = user.find_application_provider
      if provider && provider.confirmed? && provider.authenticate(params[:password])
        sign_in user
        redirect_back_or(user) and return true
      end
    end

    flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
    render 'new'
  end
end