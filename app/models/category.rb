class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id
  acts_as_tree

end
