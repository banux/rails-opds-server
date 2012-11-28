class DeleteCatalog < ActiveRecord::Migration
  def up
  	drop_table :catalog_books
  	drop_table :catalogs
  	drop_table :shared_catalogs
  end

  def down
  end
end
