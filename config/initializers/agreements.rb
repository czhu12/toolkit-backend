Agreement = Struct.new(:id, :title, :column, :updated, keyword_init: true) do
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
Rails.application.config.agreements = [
  # Agreement.new(
  #   id: :terms_of_service,
  #   title: "Terms Of Service",
  #   column: :accepted_terms_at,
  #   updated: Time.parse("2022-01-01 00:00:00")
  # ),
  # Agreement.new(
  #   id: :privacy_policy,
  #   title: "Privacy Policy",
  #   column: :accepted_privacy_at,
  #   updated: Time.parse("2022-01-01 00:00:00")
  # )
]
