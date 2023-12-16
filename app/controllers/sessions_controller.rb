class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ new create ]

  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
    @user ||= User.new
  end

  def create
    if user = User.authenticate_by(**user_params.slice(:username, :password))
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = {value: @session.id, httponly: true}

      redirect_to root_path, notice: "Signed in successfully"
    else
      @user = User.new(**user_params.slice(:username))
      @user.errors.add(:base, "Username or password is incorrect")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @session.destroy
    redirect_to sessions_path, notice: "Signed out successfully"
  end

  private

    def user_params
      params.require(:user).permit(:username, :password)
    end

    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
end
