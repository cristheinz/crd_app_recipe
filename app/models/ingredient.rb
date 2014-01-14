class Ingredient < ActiveRecord::Base
  attr_accessible :name
  has_many :portions, dependent: :destroy
  has_many :recipes, through: :portions

  before_save { |ingredient| ingredient.name = name.downcase }

  validates :name, uniqueness: { case_sensitive: false }

  def self.all_except(current_list)
	 if current_list
    select("name").where("name not in (?)",current_list) 
	 else
		select("name")
	 end
  end
end
