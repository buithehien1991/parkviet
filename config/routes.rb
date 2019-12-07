Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: { sign_in: 'dang-nhap', sign_out: 'dang-xuat', sign_up: 'dang-ky' },
             controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  root to: "home#index"

  get 'get_district_list', to: "application#get_districts"
  get 'get_commune_list', to: "application#get_communes"
  get 'manage', to: "manage#index"
  get 'sale', to: "sale#index"
  get 'dashboard', to: "sale#dashboard"
  get 'get_current_user', to: "application#get_current_user"
  get 'bang-gia', to: "home#pricing", as: :pricing

  scope :manage do
    resources :invoices
    resources :products do
      member do
        get 'update_status'
      end
    end
    resources :customers do
      collection do
        get 'search'
      end
    end
    resources :suppliers do
      collection do
        get 'search'
      end
    end
    resources :product_groups
    resources :producers

    resources :purchase_orders do
      member do
        post 'status'
        get 'pdf'
      end
    end
    resources :product_purchase_orders

    resources :users
    resources :roles
    resources :purchases
    resources :reports
    resources :print_templates
  end

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :products
    end
  end
end
