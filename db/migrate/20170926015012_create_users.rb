class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.column :login,                     :string, :limit => 40, index: true, unique: true
      t.column :name,                      :string, :limit => 100, :default => '', :null => true
      t.column :email,                     :string, :limit => 100
      t.column :avatar,                    :string
      t.column :phone,                     :string, :limit => 100
      t.column :available,                 :boolean
      t.column :uid,                       :string, :limit => 40
      t.column :number,                    :string, limit: 191, index: true
      t.column :uuid,                      :string, limit: 18
      t.column :gender,                    :string
      t.column :category,                  :integer
      t.column :syn,                       :integer
      t.column :school_ids,                :text
      t.column :status,                    :integer, default: 0
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime

      t.timestamps
    end
  end
end