class CreateApiKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :api_keys do |t|
      t.integer :user_id, index: true
      t.string  :access_token, limit: 191, index: true
      t.datetime :expire_at
      t.integer :source

      t.timestamps
    end
  end
end
