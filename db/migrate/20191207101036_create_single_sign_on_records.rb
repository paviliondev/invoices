class CreateSingleSignOnRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :single_sign_on_records do |t|
      t.references :user, foreign_key: true
      t.string :external_id
      t.text :last_payload
      t.string :external_username
      t.string :external_email
      t.string :external_name

      t.timestamps
    end
  end
end
