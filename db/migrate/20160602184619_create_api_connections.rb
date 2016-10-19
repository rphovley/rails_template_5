class CreateApiConnections < ActiveRecord::Migration
  def change
    create_table :api_connections do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :token
      t.text :meta_data
      t.string :device_type

      t.timestamps null: false
    end
  end
end
