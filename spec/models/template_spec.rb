require "rails_helper"

RSpec.describe Template, :type => :model do
  it "must have a name" do
    template = Template.new(template: 'hello!')
    expect(template).not_to be_valid
  end

  it "must have a template" do
    template = Template.new(name: 'nice!')
    expect(template).not_to be_valid
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
