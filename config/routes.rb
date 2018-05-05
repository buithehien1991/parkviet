Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: { sign_in: 'dang-nhap', sign_out: 'logout', sign_up: 'dang-ky' },
             controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  root to: "home#index"
  get 'sale/index'
  get 'manage/index'
end
