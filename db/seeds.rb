# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# Uncomment the following to create an Admin user for Production in Jumpstart Pro
#
#   user = User.create(
#     name: "Admin User",
#     email: "email@example.org",
#     password: "password",
#     password_confirmation: "password",
#     terms_of_service: true
#   )
#   Jumpstart.grant_system_admin!(user)
