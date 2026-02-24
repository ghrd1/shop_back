# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      # Stateless API auth: issue a Devise-compatible JWT and do not create a session cookie.
      token, = Warden::JWTAuth::UserEncoder.new.call(resource, resource_name, nil)
      
      render json: { 
        user: resource, 
        token: token 
      }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Permit first_name and last_name during sign up
  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name
    )
  end
end
