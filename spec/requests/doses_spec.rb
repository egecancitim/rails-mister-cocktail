require 'rails_helper'

RSpec.describe 'Doses', type: :request do
  let(:cocktail) { Cocktail.create!(name: 'Gin Tonic') }
  let(:other_cocktail) { Cocktail.create!(name: 'Tom Collins') }
  let(:ingredient) { Ingredient.create!(name: 'Gin') }

  describe 'POST /cocktails/:cocktail_id/doses' do
    it 'creates a dose and redirects to cocktail page' do
      expect do
        post cocktail_doses_path(cocktail), params: {
          dose: { description: '2 oz', ingredient_id: ingredient.id }
        }
      end.to change(Dose, :count).by(1)

      expect(response).to redirect_to(cocktail_path(cocktail))
    end

    it 'returns unprocessable entity when description is missing' do
      expect do
        post cocktail_doses_path(cocktail), params: {
          dose: { description: '', ingredient_id: ingredient.id }
        }
      end.not_to change(Dose, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('Gin Tonic')
    end

    it 'returns unprocessable entity for duplicate ingredient in same cocktail' do
      Dose.create!(description: '2 oz', cocktail: cocktail, ingredient: ingredient)

      expect do
        post cocktail_doses_path(cocktail), params: {
          dose: { description: '1 oz', ingredient_id: ingredient.id }
        }
      end.not_to change(Dose, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'allows the same ingredient for a different cocktail' do
      Dose.create!(description: '2 oz', cocktail: cocktail, ingredient: ingredient)

      expect do
        post cocktail_doses_path(other_cocktail), params: {
          dose: { description: '1.5 oz', ingredient_id: ingredient.id }
        }
      end.to change(Dose, :count).by(1)

      expect(response).to redirect_to(cocktail_path(other_cocktail))
    end
  end

  describe 'DELETE /doses/:id' do
    it 'deletes dose and redirects to cocktail page' do
      dose = Dose.create!(description: '2 oz', cocktail: cocktail, ingredient: ingredient)

      expect do
        delete dose_path(dose)
      end.to change(Dose, :count).by(-1)

      expect(response).to redirect_to(cocktail_path(cocktail))
    end
  end
end
