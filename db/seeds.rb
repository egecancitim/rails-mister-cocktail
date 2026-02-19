require "open-uri"
require "json"

puts "Cleaning database..."
Dose.destroy_all
Cocktail.destroy_all
Ingredient.destroy_all

def fetch_json(url)
  JSON.parse(URI.open(url).read)
end

def seed_ingredients
  puts "Importing ingredients..."
  payload = fetch_json("https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list")

  payload.fetch("drinks", []).each do |ingredient_row|
    name = ingredient_row["strIngredient1"]&.strip
    next if name.nil? || name.empty?

    Ingredient.find_or_create_by!(name: name)
  end
end

def seed_random_cocktails(count)
  puts "Importing #{count} random cocktails..."

  count.times do
    payload = fetch_json("https://www.thecocktaildb.com/api/json/v1/1/random.php")
    drink = payload.fetch("drinks", []).first
    next unless drink

    cocktail_name = drink["strDrink"]&.strip
    next if cocktail_name.nil? || cocktail_name.empty?

    cocktail = Cocktail.find_or_create_by!(name: cocktail_name)

    (1..15).each do |i|
      ingredient_name = drink["strIngredient#{i}"]&.strip
      next if ingredient_name.nil? || ingredient_name.empty?

      ingredient = Ingredient.find_or_create_by!(name: ingredient_name)
      measure = drink["strMeasure#{i}"]&.strip.presence || "to taste"

      dose = Dose.find_or_initialize_by(cocktail: cocktail, ingredient: ingredient)
      dose.description = measure
      dose.save!
    end

    puts "#{cocktail.name} created/updated"
  end
end

seed_ingredients
seed_random_cocktails(20)

puts "Seeds completed."
