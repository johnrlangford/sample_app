require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal "Ruby on Rails Tutorial Sample App", full_title
    assert_equal "Contact | #{full_title}", full_title("Contact")
  end
end
