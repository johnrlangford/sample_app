require "test_helper"

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:john)
  end

  test "bad login info" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "john@example.com", password: "" } }
    assert_template 'sessions/new'
    assert_response :unprocessable_entity
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "good login info followed by logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, password: "password" } }
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0

  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '1')
    log_in_as(@user, remember_me: '0')
    assert cookies[:remember_token]
  end

  test "login with remembering" do
    log_in_as(@user)
    assert BCrypt::Password.new(assigns(:user).remember_digest).is_password?(cookies[:remember_token])
  end
end
