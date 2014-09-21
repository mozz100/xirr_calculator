require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    @account = accounts(:pension)
    sign_in users(:alice)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post :create, account: { code: @account.code, name: @account.name }
    end

    assert_redirected_to account_path(assigns(:account))
  end

  test "should reject accounts without name" do
    assert_difference('Account.count', 0) do
      post :create, account: { code: @account.code, name: "" }
    end

    assert_response :success
  end

  test "should show account" do
    get :show, id: @account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @account
    assert_response :success
  end

  test "should update account" do
    patch :update, id: @account, account: { code: @account.code, name: @account.name }
    assert_redirected_to account_path(assigns(:account))
  end

  test "should reject updates without name" do
    patch :update, id: @account, account: { code: @account.code, name: "" }
    assert_template :edit
    assert_response :success
  end

  test "should destroy account and entries" do
    num_entries = @account.entries.count
    assert num_entries > 0
    assert_difference('Entry.count', -num_entries) do
      assert_difference('Account.count', -1) do
        delete :destroy, id: @account
      end
    end

    assert_redirected_to accounts_path
  end
end
