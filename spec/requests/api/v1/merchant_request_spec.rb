require 'rails_helper'

describe 'Books API' do
  it 'sends a list of books' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    merchants = JSON.parse(response.body)
    expect(merchants.count).to eq(3)
    merchants.each do |merchant|
      expect(merchant).to have_key('name')
      expect(merchant['name']).to be_an(String)
      expect(merchant).to have_key('id')
      expect(merchant['id']).to be_an(Integer)
    end
  end

end
