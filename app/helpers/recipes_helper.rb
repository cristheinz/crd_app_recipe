module RecipesHelper
	def recipe_correct_user(recipe)
		Recipe.joins(:source).where("user_id = ?",current_user.id).include?(recipe)
	end
end
