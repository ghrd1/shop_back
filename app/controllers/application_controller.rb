class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_admin!
    render json: { error: 'Forbidden' }, status: :forbidden unless current_user&.admin?
  end
end
