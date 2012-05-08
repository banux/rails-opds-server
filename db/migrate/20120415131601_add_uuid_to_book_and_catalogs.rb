class AddUuidToBookAndCatalogs < ActiveRecord::Migration
  def change
    add_column :catalogs, :uuid, :string, :limit => 36
    add_column :books, :uuid, :string, :limit => 36

    Book.all.each do |b| b.save end
    Catalog.all.each do |c| c.save end
  end
end
