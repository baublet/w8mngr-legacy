Rails.application.routes.draw do
    root   'welcome#index'
    get    'signup'         => 'users#new'
    get    'login'          => 'sessions#new'
    post   'login'          => 'sessions#create'
    delete 'logout'         => 'sessions#destroy'
    get    'foodlog'        => 'food_entries#index'
    get    '/foodlog/:day'  => 'food_entries#index'
    resources :food_entries,only: [:index, :create, :update, :destroy]
    resources :users
end
