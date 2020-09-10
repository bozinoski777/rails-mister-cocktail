require 'json'
require 'open-uri'

url = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a'
cocktail_serialized = open(url).read
cocktails = JSON.parse(cocktail_serialized)

# seed cocktails
cocktails['drinks'].each do |cocktail|
  cocky = Cocktail.create!(name: cocktail['strDrink'], description: cocktail['strInstructions'], seed_id: cocktail['idDrink'])
  # Seed images
  file = URI.open(cocktail['strDrinkThumb'])
  cocky.photo.attach(io: file, filename: "#{cocktail['strDrink'].gsub(" ", "")}.#{cocktail['strDrinkThumb'][0...-3]}", content_type: 'image/png')
end
ingredient_description_groups = []
# fetch and convert ingredients
i = 1
cocktails['drinks'].each do |cocktail|
  n = 1
  group = {}
  group["idDrink#{i}"] = cocktail["idDrink"]

  15.times do
    unless cocktail["strIngredient#{n}"].nil?
      group[cocktail["strIngredient#{n}"]] = cocktail["strMeasure#{n}"].nil? ? '1 oz' : cocktail["strMeasure#{n}"]
      n += 1
    end
  end
  ingredient_description_groups << group
  i += 1
end
# seed ingredients
ingredient_description_groups.each do |cocktail|
  p ingredient_description_groups
  # cocktail.reject! { |k, _| k.match(/(idDrink\d\d|idDrink\d)/) }

    cocktail.each do |k, _|
      ingredient_names = Ingredient.pluck(:name)
      # unless k.match?(/(idDrink\d\d|idDrink\d)/)
       if !ingredient_names.include? k
        Ingredient.create!(name: k)
      end
      # end
    end

end
Cocktail.all.each do |cocktail|
  x = 1
  ingredient_description_groups.each do |ingredient_description_pair|
# ISSUE WITH FOLLOWING IF STATEMENT
    if ingredient_description_pair["idDrink#{x}"] == cocktail.seed_id
      ingredient_description_pair.each do |k, v|
      unless k.match?(/(idDrink\d\d|idDrink\d)/)
        Dose.create!(
          cocktail: cocktail,
          description: v,
          ingredient: Ingredient.find_by(name: k))
      end
      end
    end
    x += 1
  end
end

