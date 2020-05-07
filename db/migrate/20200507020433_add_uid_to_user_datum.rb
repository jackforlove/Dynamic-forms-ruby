class AddUidToUserDatum < ActiveRecord::Migration[5.2]
  def change
    add_column :user_data, :uid, :integer
  end
end
