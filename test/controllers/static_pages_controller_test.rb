require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  #def setup
  #  @base_title = "Ruby on Rails Tutorial Sample App"
  #end
  
  test "should get root" do
    get root_path
    #get root_url これはどっちでも良い
    assert_response :success
  end
  
  test "should get home" do   # homeページのテスト
    get root_path
    #get static_pages_home_url # Getリクエストをhomeアクションに対して発行せよ。
    assert_response :success  # そうすれば、リクエストに対するレスポンスは[成功]になる。
    assert_select "title", "Ruby on Rails Tutorial Sample App"
    #assert_select "title", "Home | #{@base_title}" 
    # <title>タグ内に「Home | Ruby on Rails Tutorial Sample App」という文字列があるかどうか。
  end

  test "should get help" do
    get help_path
    #get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | Ruby on Rails Tutorial Sample App"
    #assert_select "title", "Help | #{@base_title}"
  end
  
  test "should get about" do
    get about_path
    #get static_pages_about_url
    assert_response :success
    assert_select "title", "About | Ruby on Rails Tutorial Sample App"
    #assert_select "title", "About | #{@base_title}"
  end
  
  test "should get contact" do
    get contact_path
    #get static_pages_contact_url
    assert_response :success
    assert_select "title", "Contact | Ruby on Rails Tutorial Sample App"
    #assert_select "title", "Contact | #{@base_title}"
  end

end
