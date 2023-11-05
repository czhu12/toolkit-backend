# == Schema Information
#
# Table name: scripts
#
#  id          :bigint           not null, primary key
#  code        :text             default("")
#  description :string
#  run_count   :bigint           default(0), not null
#  slug        :string           not null
#  title       :string           not null
#  visibility  :integer          default("public")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_scripts_on_slug  (slug) UNIQUE
#
class Script < ApplicationRecord
  include PgSearch::Model
  extend FriendlyId
  friendly_id :slug, use: :slugged
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :scripts, partial: "scripts/index", locals: {script: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :scripts, target: dom_id(self, :index) }

  pg_search_scope :search_for, against: [:title, :description], using: {
    tsearch: { prefix: true }
  }
  validates_presence_of :title
  validates_presence_of :visibility
  validates_presence_of :slug
  validates_uniqueness_of :slug

  belongs_to :user, optional: true
  enum visibility: {
    public: 0,
    private: 1,
  }, _suffix: true

  after_initialize :create_slug

  def create_slug
    if slug.blank?
      self.slug = SecureRandom.uuid
    end
  end

  def increment!
    self.update(run_count: self.run_count + 1)
  end
end
