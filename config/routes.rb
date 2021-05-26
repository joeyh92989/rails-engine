Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show]
      resources :items
      namespace :merchants do
        get '/merchants/:id/items', to: 'merchant_items#index'
      end
      namespace :items do
        get '/items/:id/merchants', to: 'item_merchants#index'
      end
    end
  end
end
