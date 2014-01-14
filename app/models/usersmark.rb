class Usersmark < ActiveRecord::Base
  attr_accessible :note, :mark_type, :recipe_id, :user_id

  has_one :user
  belongs_to :recipe

  validates :user_id, presence: true
  validates :recipe_id, presence: true
  validates :mark_type, presence: true

  def self.favorite
  	where("mark_type in (1,3)")
  end

  def self.cart
  	where("mark_type in (2,3)")
  end
end
