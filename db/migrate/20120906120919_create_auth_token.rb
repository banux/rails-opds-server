class CreateAuthToken < ActiveRecord::Migration
  def up
    User.all.each do |u|
	u.ensure_authentication_token!
    end
  end

  def down
  end
end
