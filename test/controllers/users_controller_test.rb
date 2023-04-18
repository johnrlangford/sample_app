require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @other_user = users(:fred)
  end

  test "should get index" do
    get users_path
    assert_redirected_to login_path
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email
    }}
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "should not be able to delete user if not logged in" do
    assert_difference "User.count", 0 do
      delete user_path(@other_user), params: {
                                      user: { password:              "password",
                                              password_confirmation: "password",
                                              admin: true } }
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test "should not be able to delete user if not admin" do
    log_in_as @other_user
    assert_difference "User.count", 0 do
      delete user_path(@other_user), params: {
                                      user: { password:              "password",
                                              password_confirmation: "password",
                                              admin: true } }
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
end
