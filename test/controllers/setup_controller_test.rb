require 'test_helper'

class SetupControllerTest < ActionController::TestCase

  test "redirect to correct urls, not signed in" do
    get :new_user
    assert_redirected_to new_user_session_path # user exists, must sign in

    post :create_user
    assert_response 401

    get :edit_settings
    assert_redirected_to new_user_session_path

    post :save_settings
    assert_redirected_to new_user_session_path
  end

  test "redirect to correct urls, signed in" do
    sign_in users(:alice)
    get :new_user
    assert_redirected_to :edit_settings # user exists, signed in

    post :create_user
    assert_response 401

    get :edit_settings
    assert_redirected_to accounts_path # no settings for now

    post :save_settings
    assert_redirected_to accounts_path # no settings for now

  end

  test "empty user database" do
    User.destroy_all
    get :new_user
    assert_response :success

    get :edit_settings
    assert_redirected_to new_user_session_path # haven't created user yet

    post :save_settings
    assert_redirected_to new_user_session_path # haven't created user yet

    # ok now create a user
    post :create_user, user: { email: "test@example.com", password: "asdfasdf", password_confirmation: "asdfasdf" }
    assert_redirected_to :edit_settings

    get :edit_settings
    assert_redirected_to accounts_path # no settings for now

    post :save_settings
    assert_redirected_to accounts_path # no settings for now
  end    

  test "should reject invalid user data" do
    User.destroy_all
    post :create_user, user: { email: "invalid", password: "asdfasdf", password_confirmation: "asdfasdf" }
    assert_template :new_user
    assert_equal flash[:alert], "Invalid submission"

    post :create_user, user: { email: "valid@example.com", password: "asdfasdf", password_confirmation: "non-match" }
    assert_template :new_user
    assert_equal flash[:alert], "Invalid submission"

  end

end
