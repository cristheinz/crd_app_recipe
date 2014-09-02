namespace :xml do
  desc "Test"
  task :test do
    require 'google-search'
    Google::Search::Image.new(:query => 'Cookies').each do |image|
      puts image.uri
    end
  end

  desc "Array Test"
  task :array_test do
    a = [{id: "1", val: "2"}, {id: "2", val: "3"}]
    b = [{id: "1", val: "0"}, {id: "2", val: "0"}, {id: "3", val: "0"}]

    #new_list = b.reject { |k| a[:id].include? k[:id] }
    #keep_list = b.select { |k| a[:id].include? k[:id] }

    new_list = b.reject { |k| a.map{|c| c[:id]}.include? k[:id]  }
    keep_list = a.select { |k| b.map{|c| c[:id]}.include? k[:id] }

    #aa = a.map{|x| x[:id]}
    #bb = b.map{|y| y[:id]}

    #new_list = bb.reject { |k| aa.include? k }
    #keep_list = bb.select { |k| aa.include? k }


    puts "new_list:"
    puts new_list
    puts "keep_list:"
    puts keep_list
    puts "both:"
    puts new_list + keep_list

  end

  desc "Resume XML data" 
  task :resume do
    require 'nokogiri'
    f = File.open("#{Rails.root}/lib/tasks/201406_revista_43.xml")
    doc = Nokogiri::XML(f)
    i_array = doc.css("ingredient").map {|node| node.inner_text }
    r_array = doc.css("recipe").map {|node| node['name'] }
    c_array = doc.css("category").map {|node| node['name'] }
    puts "Source '#{doc.css("source").first['name']}' contains:"
    puts " - #{c_array.uniq.size} Categories"
    puts " - #{r_array.uniq.size} Recipes"
    puts " - #{i_array.uniq.size} Ingredients"
    f.close
  end

  desc "List XML data" 
  task :list, :element do |t, args|
    #args.with_defaults(element: "source")
    args.with_defaults(element: "ingredient")
    require 'nokogiri'
    f = File.open("#{Rails.root}/lib/tasks/201406_revista_43.xml")
    doc = Nokogiri::XML(f)
    i_array = []
    doc.css("#{args[:element]}").each do |node|
      children = node.children
      s=node.inner_text 
      s=node['name'] unless args[:element]=="ingredient"
      i_array.push(s) unless i_array.include?(s)
    end
    puts i_array.sort
    f.close
  end

  desc "List XML data" 
  task :newingredients => :environment do
    require 'nokogiri'
    f = File.open("#{Rails.root}/lib/tasks/201406_revista_43.xml")
    doc = Nokogiri::XML(f)
    i_array = []
    doc.css("ingredient").each do |node|
      s=node.inner_text 
      ingredient=Ingredient.find_by_name(s.downcase)
      i_array.push(s) unless i_array.include?(s) || ingredient
    end
    puts i_array.sort
    f.close
  end

  desc "List XML data" 
  task :newcategories => :environment do
    require 'nokogiri'
    f = File.open("#{Rails.root}/lib/tasks/201406_revista_43.xml")
    doc = Nokogiri::XML(f)
    i_array = []
    doc.css("category").each do |node|
      s=node["name"] 
      category=Category.find_by_name(s)
      i_array.push(s) unless i_array.include?(s) || category
    end
    puts i_array.sort
    f.close
  end

  desc "List XML data" 
  task :newrecipes => :environment do
    require 'nokogiri'
    f = File.open("#{Rails.root}/lib/tasks/201406_revista_43.xml")
    doc = Nokogiri::XML(f)
    i_array = []
    doc.css("recipe").each do |node|
      s=node["name"] 
      i_array.push(s)
    end
    puts i_array.sort
    f.close
  end

  desc "List XML data" 
  task :checkportions => :environment do
    require 'nokogiri'
    f = File.open("#{Rails.root}/lib/tasks/201406_revista_43.xml")
    doc = Nokogiri::XML(f)
    i_array = []
    doc.css("ingredient").each do |node|
      s=node["portion"] ? node["portion"] : ""  
      i_array.push(s) unless i_array.include?(s)
    end
    puts i_array.sort
    f.close
  end

  desc "List XML data" 
  task :checknotes => :environment do
    require 'nokogiri'
    f = File.open("#{Rails.root}/lib/tasks/201406_revista_43.xml")
    doc = Nokogiri::XML(f)
    i_array = []
    doc.css("ingredient").each do |node|
      s=node["note"] ? node["note"] : ""  
      i_array.push(s) unless i_array.include?(s)
    end
    puts i_array.sort
    f.close
  end

  desc "List XML data" 
  task :checkparts => :environment do
    require 'nokogiri'
    f = File.open("#{Rails.root}/lib/tasks/201406_revista_43.xml")
    doc = Nokogiri::XML(f)
    i_array = []
    doc.css("ingredient").each do |node|
      s=node["part"] ? node["part"] : ""  
      i_array.push(s) unless i_array.include?(s)
    end
    puts i_array.sort
    f.close
  end

  desc "List XML data" 
  task :timecheck => :environment do
    require 'nokogiri'
    f = File.open("#{Rails.root}/lib/tasks/201406_revista_43.xml")
    doc = Nokogiri::XML(f)
    i_array = []
    doc.css("recipe").each do |node|
      s=node["prep_time"] 
      i_array.push(s) unless i_array.include?(s)
    end
    puts i_array.sort
    f.close
  end

  desc "List XML data" 
  task :lvlcheck => :environment do
    require 'nokogiri'
    f = File.open("#{Rails.root}/lib/tasks/201406_revista_43.xml")
    doc = Nokogiri::XML(f)
    i_array = []
    doc.css("recipe").each do |node|
      s=node["difficult_level"] 
      i_array.push(s) unless i_array.include?(s)
    end
    puts i_array.sort
    f.close
  end
  
  desc "List XML data" 
  task :aaa => :environment do
    #require 'nokogiri'
    #f = File.open("#{Rails.root}/lib/tasks/201310_revista_35.xml")
    #doc = Nokogiri::XML(f)
    i_array = []
    #i_array.push("id;tbl;usr;src;rec")
    User.all.each do |user|
      user.usersbooks.each do |book|
        source = Source.find(book.source_id)
        #i_array.push(book.id.to_s+";books;"+user.id.to_s+";"+source.name+";")
        i_array.push(id: book.id, tbl: "books", usr: user.id, src: source.name, rec: "")
      end
      user.usersmarks.each do |mark|
        recipe = Recipe.find(mark.recipe_id)
        source = Source.find(recipe.source_id)
        #i_array.push(mark.id.to_s+";marks;"+user.id.to_s+";"+source.name+";"+recipe.name) if source.public?
        i_array.push(id: mark.id, tbl: "marks", usr: user.id, src: source.name, rec: recipe.name) if source.public?
      end
    end
    #puts i_array
    i_array.each do |a|
      puts "id : "+a[:id].to_s
      puts "tbl: "+a[:tbl]
      puts "usr: "+a[:usr].to_s
      puts "src: "+a[:src]
      puts "rec: "+a[:rec]
      puts "**************"
    end
  end
  

  desc "Import XML into Database" 
  task :import => :environment do
    require 'nokogiri'
    #f = File.open("#{Rails.root}/lib/tasks/receitas_essenciais.xml")
    #f = File.open("#{Rails.root}/lib/tasks/massas_e_doces.xml")
    #f = File.open("#{Rails.root}/lib/tasks/201308_revista_33.xml")
    #f = File.open("#{Rails.root}/lib/tasks/201309_revista_34.xml")
    #f = File.open("#{Rails.root}/lib/tasks/201310_revista_35.xml")
    #f = File.open("#{Rails.root}/lib/tasks/201311_revista_36.xml")
    #f = File.open("#{Rails.root}/lib/tasks/201312_revista_37.xml")
    #f = File.open("#{Rails.root}/lib/tasks/201401_revista_38.xml")
    #f = File.open("#{Rails.root}/lib/tasks/201402_revista_39.xml")
    #f = File.open("#{Rails.root}/lib/tasks/201403_revista_40.xml")
    #f = File.open("#{Rails.root}/lib/tasks/201404_revista_41.xml")
    #f = File.open("#{Rails.root}/lib/tasks/201405_revista_42.xml")
    f = File.open("#{Rails.root}/lib/tasks/201406_revista_43.xml")
    #f = File.open("#{Rails.root}/lib/tasks/paosaloio.xml")
    #f = File.open("#{Rails.root}/lib/tasks/receitas_utf8.xml")
    doc = Nokogiri::XML(f)
    #puts "aaaaaaaaaaaaaa"
    #quando carregar parceiros, deve criar um user para ele c/email e pwd
    #o nome do source no xml deve ser a url do blog ou site
    user=User.find_by_name("admin")
    unless user
      user=User.create(name: "admin", 
        email: "admin@somewhere.com", 
        password: "password", 
        password_confirmation: "password")
      user.admin='t'
      if user.save
        puts "user save ....[OK]"
      else
        puts "user save ....[ERROR]"
      end
    end
  
    doc.xpath("//sources/source").each do |s|
      s_name=s["name"] 
      source=Source.find_by_name(s_name)
      unless source
        source= user.sources.create!(
          name: s_name, 
          publish_date: s["pub_date"], 
          public: 't')
        #para os parceiros o source.public='f'
        puts "new source: #{source.name}" 
      end
      #apago todas as receitas e porções do source
      puts "destroing #{source.recipes.size} recipes from #{s_name}"
      #source.recipes.destroy
      source.recipes.each do |x|
        #puts "destroing #{x.name}"
        x.destroy;
      end

      s.xpath("./categories/category").each do |c|
        c_name=c["name"] 
        category=Category.find_by_name(c_name)
        unless category
          category=Category.create!(
            name: c_name)
          puts "new category: #{category.name}" 
        end
        c.xpath("./recipes/recipe").each do |r|
          r_name=r["name"]
          calories=r["calories"]
          pax=r["portions"]
          prep_time=r["prep_time"]
          difficult_level=r["difficult_level"]
          page=r["page"]
          description=r.xpath("./description").inner_text
          note=r.xpath("./note").inner_text
          rp={}
          #recipe=Recipe.find_by_name(r_name)
          #unless recipe
            recipe=source.recipes.create!(
              category_id: category.id, 
              name: r_name, 
              calories: calories, 
              pax: pax, 
              prep_time: prep_time, 
              difficult_level: difficult_level, 
              page: page, 
              description: description, 
              note: note, 
              shareable: 't')

            r.xpath("./ingredients/ingredient").each do |i| 
              i_name= i.inner_text
              ingredient=Ingredient.find_by_name(i_name.downcase)
              unless ingredient
                puts "new ingredient: #{i_name}"
                ingredient=Ingredient.create!(
                  name: i_name)
              end
              part= i["part"]
              portion= i["portion"]
              note= i["note"] 

              portion=recipe.portions.create!(
                part: part, 
                portion: portion, 
                ingredient_id: ingredient.id, 
                note: note)
            end

            puts "new recipe: #{recipe.name}"
          #end
        end
      end
    end
    f.close

    puts "#{Source.count} Sources"
    puts "#{Category.count} Categories"
    puts "#{Recipe.count} Recipes"
    puts "#{Ingredient.count} Ingredients"
    puts Recipe.last.name
  end
end