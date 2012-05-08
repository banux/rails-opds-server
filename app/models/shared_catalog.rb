class SharedCatalog < ActiveRecord::Base
	belongs_to :user
	belongs_to :catalog
end
