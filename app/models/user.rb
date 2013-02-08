class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :token_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  has_many :books
  has_many :read_lists
  has_many :reading, :through => :read_lists, :source => :book

  after_save :create_admin, :check_auth_token

  def create_admin
  	if self.id == 1 && self.admin != true
  		self.admin = true
  		self.save
  	end
  end

  def check_auth_token
  	if self.authentication_token.nil?
  		self.ensure_authentication_token!
  		self.save
  	end
  end

end
