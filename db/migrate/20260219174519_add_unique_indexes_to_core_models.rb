class AddUniqueIndexesToCoreModels < ActiveRecord::Migration[6.1]
  def change
    add_index :cocktails, :name, unique: true
    add_index :ingredients, :name, unique: true
    add_index :doses, [:cocktail_id, :ingredient_id], unique: true
  end
end
