class StaticPagesController < ApplicationController
  
  def home
    @since="1 year"
    case 
    when (Date.new(Time.now.year,Time.now.month,1) - Date.new(2013,8,1)).to_i/365 > 1
      @since="#{(Date.new(Time.now.year,Time.now.month,1) - Date.new(2013,8,1)).to_i/365} years"
    when (Date.new(Time.now.year,Time.now.month,1) - Date.new(2013,8,1)).to_i/365 == 0
      @since="#{(Time.now.year * 12 + Time.now.month) - (2013 * 12 + 8)} months"
    end
    
    tips=["Para pesquisar qualquer tipo de queijo basta adicionar <u>queijo%</u>",
      "Se quer encontrar receitas que levam frango ou peito de frango, adicione <u>%frango</u>.",
      "Aceite as nossas sugestoes de ingredientes enquanto digita.",
      "Pode remover os ingredientes um a um ou clicar em <b>Limpar</b> para remover todos de uma vez.",
      "Apos inserir os ingredientes pode pesquisar receitas dos seus livros apenas ou filtrar por categoria."
      ]
    @tip=tips[rand(0..4)]
  	if assigned_in?
      @opt=""
      #@books_only=params[:books_only] if params[:books_only] && params[:books_only]!="0"
      source_opt=params[:source_opt] if params[:source_opt]!="0"
      order_opt=params[:order_opt] if params[:order_opt]!="0"
      #@list_all=params[:all_recipes] if params[:all_recipes]
      @ingredients =Ingredient.all_except(current_list).map(&:name)
      user_id=0 
      user_id=current_user.id if current_user
      #@result=Portion.rank(current_list,params[:category_id],params[:all_recipes],user_id)
      cat_opt=nil
      cat_opt=params[:category_opt] if params[:category_opt] && !params[:category_opt].empty?
      @result=Portion.rank(current_list,cat_opt,params[:all_recipes],user_id, source_opt,order_opt)
      #blacklist=[recipe: Recipe.new]
      @result.each do |r| 
        r[:txt]=r[:recipe].highlight(current_list)
        #if signed_in? && source_opt && !r[:recipe].source.is_usersbook(current_user.id)
        #    blacklist.push(r[:recipe])
        #end
      end
      #filtered_array = @result.select { |r| !blacklist.include? r[:recipe] }
      #filtered_array = @result.reject  { |r| blacklist.include? r[:recipe] }
      #@result=filtered_array
      cat_ids=@result.map{ |d| d[:category_id] }
      @cats=Category.where("id in (?)",cat_ids).order("name")
      @result=@result.paginate(page: params[:page], per_page: 5)
      #@result=@result.paginate(page: params[:page])
      
      #if params[:category_id]
      #  @selcat = Category.find(params[:category_id]) 
      #end
    else
      @ingredients = Ingredient.find(:all,:select=>'name').map(&:name)
      @sources=Source.public_sources.limit(3)
      #@sources2=Source.where("public != ?",true).order("publish_date DESC").paginate(page: params[:page], per_page: 3)
  	end

    #respond_to do |format|
      #format.html { redirect_to root_path, notice: "aaaaaa"  }
      #format.html { render home }
      #format.js { redirect_to root_url}
    #end

  end

  def partnership
    @feedback = Feedback.new
  end

end
