class Template < ActiveRecord::Base
  acts_as_paranoid

  validates :name, presence: true
  validates :template, presence: true

  def to_s
    name
  end

end

# == Schema Information
#
# Table name: templates
#
#  id            :bigint           not null, primary key
#  deleted_at    :datetime
#  email_default :boolean          default(FALSE)
#  models        :string(200)
#  name          :string(255)
#  print_default :boolean          default(FALSE)
#  subject       :string(200)
#  template      :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_templates_on_deleted_at  (deleted_at)
#
