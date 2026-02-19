require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it 'is valid with a name' do
    expect(described_class.new(name: 'Lime')).to be_valid
  end

  it 'is invalid without a name' do
    ingredient = described_class.new(name: nil)

    expect(ingredient).not_to be_valid
    expect(ingredient.errors[:name]).to include("can't be blank")
  end

  it 'enforces unique names' do
    described_class.create!(name: 'Rum')
    duplicate = described_class.new(name: 'Rum')

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to include('has already been taken')
  end

  it 'destroys associated doses when deleted' do
    cocktail = Cocktail.create!(name: 'Daiquiri')
    ingredient = described_class.create!(name: 'Sugar syrup')
    dose = Dose.create!(description: '1 oz', cocktail: cocktail, ingredient: ingredient)

    expect { ingredient.destroy }.to change(Dose, :count).by(-1)
    expect { dose.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
