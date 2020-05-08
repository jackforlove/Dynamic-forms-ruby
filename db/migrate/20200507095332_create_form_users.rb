class CreateFormUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :form_users do |t|
      t.integer :user_id
      t.integer :form_id
      t.timestamps
    end
  end
end
