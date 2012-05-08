class AddCoverTypeToBook < ActiveRecord::Migration
  def change
    add_column :books, :cover_type, :string

  end
end
