class HomeController < ApplicationController
  before_action :set_user

  def index
    @offers = @user.offers
  end

  private

    def set_user
      @user = Current.user
    end
end
