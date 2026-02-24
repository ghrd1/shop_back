class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:index, :show, :update, :destroy]

  # GET /users/profile - show current user's profile
  def profile
    render json: current_user
  end

  # PATCH/PUT /users/profile - update current user's profile
  def update_profile
    if current_user.update(user_params)
      render json: current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  # GET /users - admin only: list all users
  def index
    render json: User.all
  end

  # GET /users/:id - admin only: show specific user
  def show
    @user = User.find(params[:id])
    render json: @user
  end

  # PATCH/PUT /users/:id - admin only: update user
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id - admin only: delete user
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    head :no_content
  end

  private

  def user_params
    # Regular users can only update their first_name and last_name
    if current_user.admin?
      params.require(:user).permit(:first_name, :last_name, :email, :role)
    else
      params.require(:user).permit(:first_name, :last_name)
    end
  end
end
