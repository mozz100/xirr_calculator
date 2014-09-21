require 'test_helper'

class SetupFromScratchTest < ActionDispatch::IntegrationTest
  setup do
    User.destroy_all
  end

  test "start from scratch" do
    get_via_redirect "/"
    assert_equal "/", path
    assert_template :new_user
    post_via_redirect "/setup/new_user", user: {email: 'someuser@example.com', password: 'abracadabra', password_confirmation: 'abracadabra'}
    assert_equal "/accounts", path
  end
end
