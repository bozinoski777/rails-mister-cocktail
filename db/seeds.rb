require 'json'
require 'open-uri'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingre_serialized = open(url).read
ingredients = JSON.parse(ingre_serialized)

ingredients.each do |ingredient|
  ingredient[1].each do |thing|
    Ingredient.create(name: thing['strIngredient1'].capitalize)
  end
end


url = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a'
cocktail_serialized = open(url).read
cocktails = JSON.parse(cocktail_serialized)

cocktails.each do |cocktail|
  cocktail[1].each do |thingy|
    n = 1
    if !thingy["strIngredient#{n}"].empty?
    begin
    p  Ingredient.create!(name: thingy["strIngredient#{n}"])
    rescue => e
      puts e
    end
    n += 1

  end
    cocktail = Cocktail.create!(name: thingy['strDrink'], description: thingy['strInstructions'])
    file = URI.open(thingy['strDrinkThumb'])
    cocktail.photo.attach(io: file, filename: "#{thingy['strDrink'].gsub(" ", "")}.#{thingy['strDrinkThumb'][0...-3]}", content_type: 'image/png')
    p cocktail
  end
end
