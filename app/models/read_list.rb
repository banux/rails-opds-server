class ReadList < ActiveRecord::Base
  attr_accessible :book_id, :position, :user_id
end
