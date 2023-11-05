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
require "test_helper"

class ScriptTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
