require 'open-uri'
require 'json'

Ingredient.destroy_all
url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
cocktails = open(url).read
cocktail_result = JSON.parse(cocktails)
cocktail_result.each
cocktail_result['drinks'].each do |ingredient|
  i = Ingredient.new(name: ingredient['strIngredient1'])
  i.save
end
puts 'seeds completed'
