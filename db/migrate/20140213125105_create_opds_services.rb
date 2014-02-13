class CreateOpdsServices < ActiveRecord::Migration
  def change
    create_table :opds_services do |t|
      t.string :url
      t.string :login
      t.string :password
      t.integer :user_id

      t.timestamps
    end
  end
end
