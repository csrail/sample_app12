require 'test_helper'

class ActiveAccountsTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:cornelius)
    @non_admin = users(:archer)
  end
  
  test "index should only show activated users" do
    log_in_as(@admin)
    get users_path
    assert_match @non_admin.name, response.body
    @non_admin.toggle!(:activated)
    get users_path
    assert_no_match @non_admin.name, response.body
  end
  
  test "inactive user pages should not be accessible" do
    log_in_as(@admin)
    @non_admin.toggle!(:activated)
    get user_path(@non_admin)
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'static_pages/home'
  end
end
