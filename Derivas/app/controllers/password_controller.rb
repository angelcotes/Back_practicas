class PasswordController < ApplicationController
  def update
    if params[:reset_password_token] && params[:password] && params[:password_confirmation]
      user = User.reset_password_by_token({
        reset_password_token: params[:reset_password_token],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      })
      head(:not_found) and return if user.id.blank?
      head(:ok) and return if user.save
      render(json: user.errors, status: :bad_request) and return
    else
      render(
        json: { msg: 'reset_password_token or password or password_confirmation are missing' },
        status: :bad_request
      )
    end
  end
end
