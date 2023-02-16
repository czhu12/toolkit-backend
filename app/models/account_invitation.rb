# == Schema Information
#
# Table name: account_invitations
#
#  id            :bigint           not null, primary key
#  email         :string           not null
#  name          :string           not null
#  roles         :jsonb            not null
#  token         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :bigint           not null
#  invited_by_id :bigint
#
# Indexes
#
#  index_account_invitations_on_account_id     (account_id)
#  index_account_invitations_on_invited_by_id  (invited_by_id)
#  index_account_invitations_on_token          (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (invited_by_id => users.id)
#
class AccountInvitation < ApplicationRecord
  ROLES = AccountUser::ROLES

  include Rolified

  belongs_to :account
  belongs_to :invited_by, class_name: "User", optional: true
  has_secure_token

  validates :name, :email, presence: true
  validates :email, uniqueness: {scope: :account_id, message: :invited}

  def save_and_send_invite
    save && send_invite
  end

  def send_invite
    AccountInvitationsMailer.with(account_invitation: self).invite.deliver_later
  end

  def accept!(user)
    account_user = account.account_users.new(user: user, roles: roles)
    if account_user.valid?
      ApplicationRecord.transaction do
        account_user.save!
        destroy!
      end

      [account.owner, invited_by].uniq.each do |recipient|
        AcceptedInvite.with(account: account, user: user).deliver_later(recipient)
      end

      account_user
    else
      errors.add(:base, account_user.errors.full_messages.first)
      nil
    end
  end

  def reject!
    destroy
  end

  def to_param
    token
  end
end
