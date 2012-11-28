class AddSerieAndSerieNumberToBook < ActiveRecord::Migration
  def change
  	add_column :books, :serie, :string
  	add_column :books, :serie_number, :integer
  end
end
