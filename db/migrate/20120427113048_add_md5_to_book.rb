class AddMd5ToBook < ActiveRecord::Migration
  def change
    add_column :books, :md5, :string
    add_index :books, :md5

    Book.all.each do |b|
    	b.save
    end
  end
end
