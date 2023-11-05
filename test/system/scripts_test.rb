require "application_system_test_case"

class ScriptsTest < ApplicationSystemTestCase
  setup do
    @script = scripts(:one)
  end

  test "visiting the index" do
    visit scripts_url
    assert_selector "h1", text: "Scripts"
  end

  test "creating a Script" do
    visit scripts_url
    click_on "New Script"

    fill_in "Code", with: @script.code
    fill_in "Description", with: @script.description
    fill_in "Run count", with: @script.run_count
    fill_in "Slug", with: @script.slug
    fill_in "Title", with: @script.title
    fill_in "User", with: @script.user_id
    fill_in "Visibility", with: @script.visibility
    click_on "Create Script"

    assert_text "Script was successfully created"
    assert_selector "h1", text: "Scripts"
  end

  test "updating a Script" do
    visit script_url(@script)
    click_on "Edit", match: :first

    fill_in "Code", with: @script.code
    fill_in "Description", with: @script.description
    fill_in "Run count", with: @script.run_count
    fill_in "Slug", with: @script.slug
    fill_in "Title", with: @script.title
    fill_in "User", with: @script.user_id
    fill_in "Visibility", with: @script.visibility
    click_on "Update Script"

    assert_text "Script was successfully updated"
    assert_selector "h1", text: "Scripts"
  end

  test "destroying a Script" do
    visit edit_script_url(@script)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Script was successfully destroyed"
  end
end
