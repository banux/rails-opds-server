class CatalogBook < ActiveRecord::Base

belongs_to :catalog
belongs_to :book

end
