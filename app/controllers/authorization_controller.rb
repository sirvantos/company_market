class AuthorizationController < ApplicationController
  def confirm
    auth = Authorization.find_by(id: params[:id], confirmation_hash: params[:hash].downcase)
    if auth
      auth.update_attribute(:confirmation_hash, nil)
      sign_in auth.user
      flash[:success] = "Hello, we have activated your account!"
      redirect_to root_path
    else
      flash[:danger] = "Sorry, wrong confrimation hash!"
      redirect_to root_path
    end
  end
end