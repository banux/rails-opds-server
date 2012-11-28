class CreateReadLists < ActiveRecord::Migration
  def change
    create_table :read_lists do |t|
      t.integer :user_id
      t.integer :book_id
      t.integer :position

      t.timestamps
    end
  end
end
