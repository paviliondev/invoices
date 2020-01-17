# RailsSettings Model
class Settings < RailsSettings::Base
  # Global
  field :api_token
  field :currency, default: "eur"
  field :days_to_due, default: 0
  field :company_logo
  field :company_name
  field :company_address
  field :company_phone
  field :company_vat_id
  field :company_url
  field :company_email
  field :legal_terms
  field :email_subject
  field :email_body
  field :contact_email
  # Hooks
  field :event_invoice_generation_url
end

# == Schema Information
#
# Table name: settings
#
#  id         :bigint           not null, primary key
#  thing_type :string(30)
#  value      :text
#  var        :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  thing_id   :integer
#
# Indexes
#
#  index_settings_on_thing_type_and_thing_id_and_var  (thing_type,thing_id,var) UNIQUE
#
