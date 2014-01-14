class Portion < ActiveRecord::Base
  attr_accessible :ingredient_id, :portion, :recipe_id, :note, :part
  belongs_to :ingredient
  belongs_to :recipe
  has_one :source, through: :recipe

  validates :recipe_id, presence: true
  validates :ingredient_id, presence: true
  validates :portion, length: { maximum: 50 }
  validates :note, length: { maximum: 100 }
  #scope :i_robot, lambda { |ids| select("sum(case when ingredient_id in (?) then 100 else 0 end)/count(*) as ratio", ids).group("recipe_id") }
  #def self.rate_recipes
  #	select("recipe_id, sum(case when ingredient_id in (1,3) then 100 else 0 end)/count(*) as ratio").group("recipe_id")
  #end

  def self.rank(names, cat_id, get_all, id, source_opt,order_opt)
    a=[]
    names.each do |n| 
      if n.include?("%")
        Ingredient.where("name like ?",n).each do |l|
          a.push(l.id)
        end
      else
        i=Ingredient.find_by_name(n)
        a.push(i.id) if !i.nil?
      end
    end
    min_ratio=0
    max_results="25"
    ratio_str="100*count(distinct case when ingredient_id in (#{a.join(', ')}) then ingredient_id else null end)/count(distinct ingredient_id)"
    num_str="count(distinct case when ingredient_id in (#{a.join(', ')}) then ingredient_id else null end)"

    ids = Usersbook.where("user_id = ?", id).map {|i| i.source_id}

    order_by="num DESC, ratio DESC"
    case 
    when order_opt=="1" 
      order_by = "ratio DESC, num DESC"
    when order_opt=="2" 
      order_by = "case when SUBSTR(recipes.difficult_level,1,1) = 'F' then 2 when SUBSTR(recipes.difficult_level,1,1) = 'M' then 1 else 0 end DESC, num DESC, ratio DESC"
    when order_opt=="3" 
      order_by = "case when recipes.prep_time like '%Seg%' then 1 else 60 end * replace(replace(recipes.prep_time,' Min',''),' Seg','') * -1 DESC, num DESC, ratio DESC"
    when !order_opt
      order_by="num DESC, ratio DESC"
    end

    case
    when cat_id && source_opt && source_opt.eql?("1")
      select("recipe_id, #{ratio_str} as ratio, recipes.category_id, #{num_str} as num")
      .joins(:recipe)
      .joins(:source)
      .where("recipes.category_id=?",cat_id)
      .where("recipes.shareable = ? or sources.user_id=?", true, id)
      .where("sources.public = ?", true)
      .where("sources.id in (?)", ids)
      .group("recipe_id")
      .having("#{ratio_str} > ?",min_ratio)
      .order(order_by)
      .limit(max_results)
      .map {|s| {txt: "", recipe: Recipe.find(s.recipe_id), ratio2: "#{s.ratio}", category_id: s.category_id}}
    when cat_id && source_opt && source_opt.eql?("2")
      select("recipe_id, #{ratio_str} as ratio, recipes.category_id, #{num_str} as num")
      .joins(:recipe)
      .joins(:source)
      .where("recipes.category_id=?",cat_id)
      .where("recipes.shareable = ? or sources.user_id=?", true, id)
      .where("sources.public != ?", true)
      .group("recipe_id")
      .having("#{ratio_str} > ?",min_ratio)
      .order(order_by)
      .limit(max_results)
      .map {|s| {txt: "", recipe: Recipe.find(s.recipe_id), ratio2: "#{s.ratio}", category_id: s.category_id}}
    when cat_id && !source_opt
      select("recipe_id, #{ratio_str} as ratio, recipes.category_id, #{num_str} as num")
      .joins(:recipe)
      .joins(:source)
      .where("recipes.category_id=?",cat_id)
      .where("recipes.shareable = ? or sources.user_id=?", true, id)
      .where("sources.public = ?", true)
      .group("recipe_id")
      .having("#{ratio_str} > ?",min_ratio)
      .order(order_by)
      .limit(max_results)
      .map {|s| {txt: "", recipe: Recipe.find(s.recipe_id), ratio2: "#{s.ratio}", category_id: s.category_id}}
    when !cat_id && source_opt && source_opt.eql?("1")
      select("recipe_id, #{ratio_str} as ratio, recipes.category_id, #{num_str} as num")
      .joins(:recipe)
      .joins(:source)
      .where("sources.public = ?", true)
      .where("sources.id in (?)", ids)
      .group("recipe_id")
      .having("#{ratio_str} > ?",min_ratio)
      .order(order_by)
      .limit(max_results)
      .map {|s| {txt: "", recipe: Recipe.find(s.recipe_id), ratio2: "#{s.ratio}", category_id: s.category_id}}      
    when !cat_id && source_opt && source_opt.eql?("2")
      select("recipe_id, #{ratio_str} as ratio, recipes.category_id, #{num_str} as num")
      .joins(:recipe)
      .joins(:source)
      .where("sources.public != ?", true)
      .group("recipe_id")
      .having("#{ratio_str} > ?",min_ratio)
      .order(order_by)
      .limit(max_results)
      .map {|s| {txt: "", recipe: Recipe.find(s.recipe_id), ratio2: "#{s.ratio}", category_id: s.category_id}}      
    when !cat_id && !source_opt
      select("recipe_id, #{ratio_str} as ratio, recipes.category_id, #{num_str} as num")
      .joins(:recipe)
      .joins(:source)
      .where("sources.public = ?", true)
      .group("recipe_id")
      .having("#{ratio_str} > ?",min_ratio)
      .order(order_by)
      .limit(max_results)
      .map {|s| {txt: "", recipe: Recipe.find(s.recipe_id), ratio2: "#{s.ratio}", category_id: s.category_id}}      
    end

  end

end
