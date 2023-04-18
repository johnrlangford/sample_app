require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:john)
    @other = users(:fred)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select '.alert', /the form contains 4 errors/i
  end

  test "successful edit with friendly forwarding" do

    get edit_user_path(@user)
    assert_not_nil(session[:forwarding_url])
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    follow_redirect!
    assert_template 'users/edit'
    name = 'Jim Davis'
    email = 'foo@example.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
    assert session[:forwarding_url].nil?
  end
  test "should redirect to root when wrong user" do
    log_in_as(@other)
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email
    }}
    # assert_not flash.empty?
    assert_redirected_to root_path
  end
end
