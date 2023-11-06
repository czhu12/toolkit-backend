user = User.create!(
  name: "Chris Zhu",
  email: "chris.zhu12@gmail.com",
  password: "password",
  password_confirmation: "password",
  terms_of_service: true
)
account = Account.create(name: "Chris Zhu")
AccountUser.create(user:, account:)

Script.create!(title: "Documentation", slug: "docs", code: Rails.root.join("resources", "docs.js").read.strip)
