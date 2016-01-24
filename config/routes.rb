Rails.application.routes.draw do
    root   'welcome#index'
    get    'signup'          => 'users#new'
    get    'login'           => 'sessions#new'
    post   'login'           => 'sessions#create'
    delete 'logout'          => 'sessions#destroy'
    resources :food_entries
    resources :users
end
