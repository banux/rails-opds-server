class AddStatusToCatalog < ActiveRecord::Migration
  def change
    change_table :catalogs do |t|
      t.integer :status, :default => 1
    end
    Catalog.update_all ["status = ?", 1]
  end
end
