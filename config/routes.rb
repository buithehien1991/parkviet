Rails.application.routes.draw do
  root "home#index"
  devise_for :users, controllers: {
    registrations: "users/registrations", sessions: "users/sessions",
    passwords: "users/passwords", omniauth_callbacks: "users/omniauth_callbacks"
  }
  devise_scope :user do
    match "users/auth/failure", to: "users/omniauth_callbacks#failure", via: %i[get post]
    get "dang-nhap", to: redirect("/users/sign_in")
    get "dang-ky", to: redirect("/users/sign_up")
  end
  get "manage", to: "manage#index"
  get "dashboard", to: "manage#index"
  get "sale", to: "sale#index"
  resources :stores, only: [ :new, :create ] do
    member { post :switch }
  end
  scope :manage do
    resources :products, :customers, :suppliers, :producers, :product_groups, :product_types,
              :branches, :reports, :print_templates
    resources :invoices, :purchases, :purchase_orders do
      member do
        post :status
        post :payment
      end
    end
    resource :store_settings, only: [ :edit, :update ], controller: "store_settings"
    get "debts", to: "debts#index"
    resources :members, except: :show
    resources :store_roles, except: :show
  end
  namespace :admin do
    root "dashboard#index"
    resources :users, except: :show
    get "settings", to: "settings#profile", as: :settings
    scope "settings", as: :settings do
      %w[profile account appearance notifications].each do |section|
        get section, to: "settings##{section}", as: section
        patch section, to: "settings#update_#{section}"
      end
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
