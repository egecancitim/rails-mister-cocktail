require 'rails_helper'

RSpec.describe Cocktail, type: :model do
  it 'is valid with a name' do
    expect(described_class.new(name: 'Negroni')).to be_valid
  end

  it 'is invalid without a name' do
    cocktail = described_class.new(name: nil)

    expect(cocktail).not_to be_valid
    expect(cocktail.errors[:name]).to include("can't be blank")
  end

  it 'enforces unique names' do
    described_class.create!(name: 'Mojito')
    duplicate = described_class.new(name: 'Mojito')

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to include('has already been taken')
  end

  it 'destroys associated doses when deleted' do
    cocktail = described_class.create!(name: 'Margarita')
    ingredient = Ingredient.create!(name: 'Tequila')
    dose = Dose.create!(description: '2 oz', cocktail: cocktail, ingredient: ingredient)

    expect { cocktail.destroy }.to change(Dose, :count).by(-1)
    expect { dose.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
