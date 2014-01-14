module ShoppinglistHelper
  def delete_cart
    self.current_shopping_list = nil
    session.delete(:shopping_list)
  end

  def set_cart(list)
    if got_a_list?
      a=self.current_shopping_list
      b=list
      new_list = b.reject { |k| a.map{|c| c[:id]}.include? k[:id]  }#novos ingredientes o preço fica a zero
      keep_list = a.select { |k| b.map{|c| c[:id]}.include? k[:id] }#ingredientes que já estavam na lista ficam com o preço que estavam
      c = new_list + keep_list
      c.sort!{|c1,c2| c1[:name] <=> c2[:name] }
      session[:shopping_list] = c
      self.current_shopping_list = c
    else
      session[:shopping_list] = list
      self.current_shopping_list = list
    end
  end

  def got_a_list?
    !current_shopping_list.nil?
  end

  def current_shopping_list=(list)
    @current_shopping_list=list
  end

  def current_shopping_list
    @current_shopping_list ||= session[:shopping_list]
  end

end