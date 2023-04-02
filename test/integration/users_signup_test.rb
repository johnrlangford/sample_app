require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid form submission" do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "",
          email: "invalid",
          password: "foo",
          password_confirmation: "bar"
        }
      }
      assert_response :unprocessable_entity
      assert_template 'users/new'
      assert_select '#error_explanation'
      assert_select '#error_explanation ul li', 4
      assert_select '.alert', /the form contains 4 errors/i
      assert_select '#error_explanation li', /password/i
      assert_select '#error_explanation li', /email/i
      assert_select '#error_explanation li', /name/i
    end
  end

  test "valid form submission" do
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: "Example User",
          email: "user@example.com",
          password: "foobar",
          password_confirmation: "foobar"
        }
      }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash.empty?
    assert_select '.alert', /welcome/i
  end
end
