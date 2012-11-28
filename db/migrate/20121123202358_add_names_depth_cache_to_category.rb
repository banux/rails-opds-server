class AddNamesDepthCacheToCategory < ActiveRecord::Migration
  def change
  	add_column :categories, :names_depth_cache, :string

  	Category.all.each do |cat|
  		cat.cache_ancestry
  	end
  end
end
