require 'rails_helper'

RSpec.describe Dose, type: :model do
  let(:cocktail) { Cocktail.create!(name: 'Whiskey Sour') }
  let(:other_cocktail) { Cocktail.create!(name: 'Old Fashioned') }
  let(:ingredient) { Ingredient.create!(name: 'Whiskey') }

  it 'is valid with description, cocktail and ingredient' do
    dose = described_class.new(description: '2 oz', cocktail: cocktail, ingredient: ingredient)

    expect(dose).to be_valid
  end

  it 'is invalid without a description' do
    dose = described_class.new(description: nil, cocktail: cocktail, ingredient: ingredient)

    expect(dose).not_to be_valid
    expect(dose.errors[:description]).to include("can't be blank")
  end

  it 'is invalid without a cocktail' do
    dose = described_class.new(description: '2 oz', cocktail: nil, ingredient: ingredient)

    expect(dose).not_to be_valid
  end

  it 'is invalid without an ingredient' do
    dose = described_class.new(description: '2 oz', cocktail: cocktail, ingredient: nil)

    expect(dose).not_to be_valid
  end

  it 'does not allow duplicate ingredient within the same cocktail' do
    described_class.create!(description: '2 oz', cocktail: cocktail, ingredient: ingredient)
    duplicate = described_class.new(description: '1 oz', cocktail: cocktail, ingredient: ingredient)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:ingredient_id]).to include('has already been taken')
  end

  it 'allows same ingredient across different cocktails' do
    described_class.create!(description: '2 oz', cocktail: cocktail, ingredient: ingredient)
    second = described_class.new(description: '1.5 oz', cocktail: other_cocktail, ingredient: ingredient)

    expect(second).to be_valid
  end
end
