class SetupController < ApplicationController
    skip_before_action :authenticate_user!, only: [:new_user, :create_user]
  def new_user
    # if we are set up and url is root, redirect to accounts page
    if settings_set_up? and request.env["PATH_INFO"] == "/"
      redirect_to accounts_path and return
    end

    # If user already exists, we either need to redirect to log in form
    # or to the settings page, becuase we don't allow more than one user for this
    # app.
    if user_exists?
      if not user_signed_in?
        redirect_to new_user_session_path and return
      end
      redirect_to :edit_settings and return
    end

    # Allow creation of a user unless one already exists
    @new_user = User.new unless User.count > 0
  end

  def create_user
    # Can't POST to create_user if a User already exists
    if user_exists?
      render text: "Access denied", status: 401 and return
    end

    @new_user = User.new(params.require(:user).permit(:email, :password, :password_confirmation))
    if not @new_user.valid?
      flash[:alert] = "Invalid submission"
      render :new_user and return
    end

    @new_user.save
    sign_in @new_user

    redirect_to :edit_settings, notice: "Welcome."
  end

  def edit_settings
    # no settings yet
    redirect_to accounts_path, notice: "All set up."
  end

  def save_settings
    # todo
    # if not settings_set_up?
    #   redirect_to :edit_settings, alert: "Invalid settings."
    # end
    redirect_to accounts_path, notice: "All set up."
  end

  private

  def user_exists?
    User.count > 0
  end

  def settings_set_up?
    return false unless user_exists?
    # for now, no settings are required
    return true
  end
end
