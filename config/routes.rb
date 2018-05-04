Rails.application.routes.draw do
  get 'manage/index'
  devise_for :users

  root to: "home#index"

  get 'sale/index'
end
