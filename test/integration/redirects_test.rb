require 'test_helper'

class RedirectsTest < ActionDispatch::IntegrationTest

  test "redirect to login" do
    get_via_redirect "/"
    assert_equal "/users/sign_in", path
  end

  test "login" do
    post_via_redirect "/users/sign_in", user: { email: @alice.email, password: @alice.password }
    assert_equal "/accounts", path
  end

end
