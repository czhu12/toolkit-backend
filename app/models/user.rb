# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  accepted_privacy_at    :datetime
#  accepted_terms_at      :datetime
#  admin                  :boolean
#  announcements_read_at  :datetime
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_name              :string
#  last_otp_timestep      :integer
#  name                   :string
#  otp_backup_codes       :text
#  otp_required_for_login :boolean
#  otp_secret             :string
#  preferences            :jsonb
#  preferred_language     :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  time_zone              :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  include ActionText::Attachable
  include TwoFactorAuthentication
  include User::Accounts
  include User::Agreements
  include User::Theme

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, andle :trackable
  devise(*[:database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, (:omniauthable if defined? OmniAuth)].compact)

  has_noticed_notifications
  has_person_name

  # ActiveStorage Associations
  has_one_attached :avatar

  # Associations
  has_many :api_tokens, dependent: :destroy
  has_many :connected_accounts, as: :owner, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :notification_tokens, dependent: :destroy

  # We don't need users to confirm their email address on create,
  # just when they change it
  before_create :skip_confirmation!

  # Protect admin flag from editing
  attr_readonly :admin

  # Validations
  validates :name, presence: true
  validates :avatar, resizable_image: true

  # Replace with a search engine like Meilisearch, ElasticSearch, or pg_search to provide better results
  # Using arel matches allows for database agnostic like queries
  def self.search(query)
    where(arel_table[:name].matches("%#{sanitize_sql_like(query)}%"))
  end

  # When ActionText rendering mentions in plain text
  def attachable_plain_text_representation(caption = nil)
    caption || name
  end
end
