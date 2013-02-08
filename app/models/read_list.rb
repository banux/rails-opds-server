class ReadList < ActiveRecord::Base
  attr_accessible :book_id, :position, :user_id

  belongs_to :user
  belongs_to :book
end
