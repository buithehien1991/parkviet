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
  end
end
