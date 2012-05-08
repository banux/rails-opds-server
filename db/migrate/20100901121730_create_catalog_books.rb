class CreateCatalogBooks < ActiveRecord::Migration
  def self.up
    create_table :catalog_books do |t|
      t.integer :catalog_id
      t.integer :book_id

      t.timestamps
    end
  end

  def self.down
    drop_table :catalog_books
  end
end
