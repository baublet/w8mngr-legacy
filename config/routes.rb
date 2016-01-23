Rails.application.routes.draw do
    root 'welcome#index'
    get 'signup'            =>  'users#new'
    get 'users/new'
    get 'welcome/index'
    resources :food_entries
    resources :users
end
