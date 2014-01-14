class Recipe < ActiveRecord::Base
  attr_accessible :calories, :description, :name,
   :portions, :source_id, :category_id, :note, :shareable,
   :pax, :prep_time, :difficult_level, :page
  has_many :portions, dependent: :destroy
  has_many :ingredients, through: :portions
  has_many :usersmarks#, dependent: :destroy
  has_one :users, through: :sources
  belongs_to :source
  belongs_to :category

  validates :source_id, presence: true
  validates :category_id, presence: true
  validates :name, presence: true, 
            #uniqueness: { case_sensitive: true },
            length: { maximum: 255 }
  validates :description, presence: true

  def list
  	h={}
  	portions.select("part").group("part").order("max(id)").each do |p|
  		if p.part.nil?
  			h[nil] = portions.where("part is null").map {|i| "#{i.portion} #{i.ingredient.name} #{i.note}"}
  		else
  		  h[p.part] = portions.where("part = ?",p.part).map {|i| "#{i.portion} #{i.ingredient.name} #{i.note}"}
  		end
  	end
    h
  end

  def highlight(list)
    s=[]
    portions.each do |p|
      x=0
      list.each do |n|
        x=1 if p.ingredient.name.include?(n.gsub(/%/, ''))
      end
      if list.include?(p.ingredient.name) || x>0
        s.push("<b>#{p.portion} #{p.ingredient.name} #{p.note}</b>")
      else
        s.push("#{p.portion} #{p.ingredient.name} #{p.note}")
      end
    end
    s.join(" | ").html_safe
  end

  def user
    source.user
  end

end
