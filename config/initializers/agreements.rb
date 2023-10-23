# Agreements allow you to track changes to your Terms of Service, Privacy, and other agreements & policies in your application.

Agreement = Data.define(:id, :title, :column, :updated, :prompt_when_updated) do
  def accepted_by?(user)
    accepted_at = user.public_send(column)
    accepted_at.present? && accepted_at >= updated
  end

  def not_accepted_by?(user)
    !accepted_by?(user)
  end

  def to_param
    id
  end

  def to_partial_path
    "agreements/#{id}"
  end
end

# Uncomment these to enforce user agreement changes are accepted by users
# Set prompt_when_updated: true to ask the user to accept the new version
Rails.application.config.agreements = [
  # Agreement.new(
  #   id: :terms_of_service,
  #   title: "Terms Of Service",
  #   column: :accepted_terms_at,
  #   updated: Time.parse("2022-01-01 00:00:00"),
  #   prompt_when_updated: true
  # ),
  # Agreement.new(
  #   id: :privacy_policy,
  #   title: "Privacy Policy",
  #   column: :accepted_privacy_at,
  #   updated: Time.parse("2022-01-01 00:00:00"),
  #   prompt_when_updated: true
  # )
]
