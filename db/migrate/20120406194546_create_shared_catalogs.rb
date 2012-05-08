class CreateSharedCatalogs < ActiveRecord::Migration
  def change
    create_table :shared_catalogs do |t|
      t.integer :catalog_id
      t.integer :user_id

      t.timestamps
    end
  end
end
