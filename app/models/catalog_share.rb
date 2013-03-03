class CatalogShare < ActiveRecord::Base
  attr_accessible :share_user_id, :user_id

  belongs_to :user
  belongs_to :share_user, :class_name => User
end
