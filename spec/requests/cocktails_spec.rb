require 'rails_helper'

RSpec.describe 'Cocktails', type: :request do
  describe 'GET /' do
    it 'returns success' do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Mister Ege's Cocktails")
    end
  end

  describe 'GET /cocktails/:id' do
    it 'returns success for an existing cocktail' do
      cocktail = Cocktail.create!(name: 'Negroni')

      get cocktail_path(cocktail)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Negroni')
    end
  end

  describe 'POST /cocktails' do
    it 'creates a cocktail and redirects to show page' do
      expect do
        post cocktails_path, params: { cocktail: { name: 'Boulevardier' } }
      end.to change(Cocktail, :count).by(1)

      created = Cocktail.find_by!(name: 'Boulevardier')
      expect(response).to redirect_to(cocktail_path(created))
    end

    it 'does not create a cocktail with empty name' do
      expect do
        post cocktails_path, params: { cocktail: { name: '' } }
      end.not_to change(Cocktail, :count)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Create a new cocktail')
    end

    it 'does not create duplicate cocktail names' do
      Cocktail.create!(name: 'Mojito')

      expect do
        post cocktails_path, params: { cocktail: { name: 'Mojito' } }
      end.not_to change(Cocktail, :count)

      expect(response).to have_http_status(:ok)
    end
  end
end
