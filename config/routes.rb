Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/revenue/merchants', to: 'revenue#merchants_order_by_rev'
      get '/revenue/items', to: 'revenue#items_order_by_rev'
      get '/revenue/unshipped', to: 'revenue#unshipped'
      get '/revenue/merchants/:id', to: 'revenue#merchant_rev'
      get '/merchants/find_all', to: 'search#merchant_search'
      get '/items/find', to: 'search#item_search'
      resources :merchants, only: %i[index show]
      resources :items
      namespace :merchants do
        get '/:id/items', to: 'merchant_items#index'
      end
      namespace :items do
        get '/:id/merchant', to: 'item_merchants#index'
      end
    end
  end
end
