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

def create_cocktail
  url = "https://www.thecocktaildb.com/api/json/v1/1/random.php"
  cocktails = open(url).read
  cocktail_result = JSON.parse(cocktails)
  cocktail_result.each
  cocktail_result['drinks'].each do |drink|
    c = Cocktail.new(name: drink['strDrink'])
    c.save
    i = Ingredient.new(name: drink['strIngredient1'])
    i.save
    d = Dose.new(description: drink['strMeasure1'], cocktail_id: c.id, ingredient_id: i.id)
    d.save
    ii = Ingredient.new(name: drink['strIngredient2'])
    ii.save
    dd = Dose.new(description: drink['strMeasure2'], cocktail_id: c.id, ingredient_id: ii.id)
    dd.save
  puts "#{c.name} created"
  end
end

create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail
create_cocktail

puts 'seeds completed'
