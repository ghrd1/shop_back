# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate(auth_options)
    unless resource
      render json: { error: "Invalid email or password" }, status: :unauthorized
      return
    end

    # Stateless API auth: issue a Devise-compatible JWT and do not create a session cookie.
    token, = Warden::JWTAuth::UserEncoder.new.call(resource, resource_name, nil)
    
    render json: { 
      user: resource, 
      token: token 
    }
  end

  def destroy
    signed_out = sign_out(resource_name)
    render json: { message: signed_out ? "Signed out successfully" : "Already signed out" }
  end
end
