class AddImageToUser < ActiveRecord::Migration
  def change
  	add_column :users, :image_uri, :string
  end
end
