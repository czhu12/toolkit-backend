require "application_system_test_case"

class LoginSystemTest < ApplicationSystemTestCase
  setup do
    Capybara.app_host = "http://lvh.me"
    Capybara.always_include_port = true
  end

  test "can login" do
    login_with_email_and_password users(:one).email, "password"
    assert_selector "p", text: I18n.t("devise.sessions.signed_in")
  end

  test "handles invalid email" do
    login_with_email_and_password "missing@example.org", "password"
    assert_selector "p", text: I18n.t("devise.failure.invalid", authentication_keys: "Email")
  end

  test "two factor required" do
    login_with_email_and_password users(:twofactor).email, "password"
    assert_selector "h1", text: I18n.t("users.two_factor.header")
  end

  test "two factor success with otp password" do
    login_with_email_and_password users(:twofactor).email, "password"
    submit_otp users(:twofactor).current_otp
    assert_selector "p", text: I18n.t("devise.sessions.signed_in")
  end

  test "two factor success with otp backup code" do
    user = users(:twofactor)
    login_with_email_and_password user.email, "password"
    submit_otp user.otp_backup_codes[0]
    assert_selector "p", text: I18n.t("devise.sessions.signed_in")
  end

  test "two factor fails with bad input" do
    login_with_email_and_password users(:twofactor).email, "password"
    submit_otp "invalid"
    assert_selector "p", text: I18n.t("users.sessions.create.incorrect_verification_code")
  end

  test "two factor always enforced for separate user logins" do
    login_with_email_and_password users(:twofactor).email, "password"
    submit_otp "invalid"
    assert_selector "p", text: I18n.t("users.sessions.create.incorrect_verification_code")

    second_user = users(:twofactor).dup
    second_user.update!(email: "twofactor2@example.org", password: "abcd1234", password_confirmation: "abcd1234", terms_of_service: true)
    login_with_email_and_password second_user.email, "abcd1234"
    submit_otp "invalid"
    assert_selector "p", text: I18n.t("users.sessions.create.incorrect_verification_code")
  end

  private

  def login_with_email_and_password(email, password)
    visit new_user_session_path

    fill_in "user[email]", with: email
    fill_in "user[password]", with: password
    find('input[name="commit"]').click
  end

  def submit_otp(otp)
    fill_in "otp_attempt", with: otp
    find('input[name="commit"]').click
  end
end
