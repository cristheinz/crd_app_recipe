module AssignmentsHelper
  def deassign
    self.current_list = nil
    session.delete(:remember_me)
  end

  def assign_in(list)
    session[:remember_me] = list
    self.current_list = list
  end

  def assigned_in?
    !current_list.nil?
  end

  def current_list=(list)
    @current_list=list
  end

  def current_list
    @current_list ||= session[:remember_me]
  end

end