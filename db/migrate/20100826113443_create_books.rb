class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :author
      t.string :title
      t.text :description
      t.string :epub
      t.string :cover
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
