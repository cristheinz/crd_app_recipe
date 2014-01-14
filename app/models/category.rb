class Category < ActiveRecord::Base
  attr_accessible :name
  has_many :recipes

  validates :name, presence: true, uniqueness: { case_sensitive: true }

  #before_save { |category| category.name = name.downcase }
  def self.from_source(source_id)
  	joins(:recipes).where("recipes.source_id=?",source_id).group("name")
  end
end
