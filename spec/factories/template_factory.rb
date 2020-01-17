FactoryBot.define do
  factory :template do
    name { "print_default" }
    template { "fake template" }
    print_default { true }

    factory :print_template do
      name { "Print Default" }
      template { "PDF Template" }
      print_default { true }
      email_default { false }
    end

    factory :email_template do
      name { "Email Default" }
      template { "Email Template" }
      email_default { true }
      print_default { false }
    end
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
