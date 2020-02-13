require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get pages_home_path
    assert_response :success
  end

  test 'should get contact' do
    get contact_path
    assert_response :success
  end
end
