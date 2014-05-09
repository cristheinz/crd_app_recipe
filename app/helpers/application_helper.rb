module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Bimbyfy"
    if page_title.empty?
      base_title
    else
      #"#{base_title} | #{page_title}"
      page_title
    end
  end
  
  def full_description(page_description)
    base_description = "Permite descobrir facilmente quais receitas podera fazer com os ingredientes da sua despensa e muito mais.."
    if page_description.empty?
      base_description
    else
      page_description
    end
  end
  
  def source_type(source_name)
    if source_name.include?("Momento")
      "Revista Bimby #{source_name}"
    else
      "Livro Bimby - #{source_name}"
    end
  end

  def get_badge(ratio)
  	str=case ratio.to_i
		when 0..40 then ""
        when 41..65 then "label-inverse"
        when 66..99 then "label-warning"
        else "label-success"
    end
    "<span class=\"span12 label #{str}\">#{number_with_precision(ratio, precision: 0)}%</span>".html_safe
  end

  def home_page?
    URI(request.url).path.to_s == "/" && !assigned_in?
    #if Rails.env.production?
    #  URI(request.url).path.to_s == "/recipe/" && !assigned_in? 
    #else
    #  URI(request.url).path.to_s == "/" && !assigned_in? 
    #end
  end

  def fb_page?
    (URI(request.url).path.to_s == "/" && !assigned_in?) 
    # || URI(request.url).path.to_s.include?("/recipes/")
  end
end
