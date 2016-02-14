Rails.application.routes.draw do
    # Static pages
    root   'welcome#index'
    get    'privacy'        => 'welcome#privacy_policy'
    get    'contact'        => 'welcome#contact_form'
    get    'getting_started'=> 'welcome#getting_started'
    get    'terms_of_service'=> 'welcome#terms_of_service'
    
    # Users and sessions
    resources :users
    get    'signup'         => 'users#new'
    get    'login'          => 'sessions#new'
    post   'login'          => 'sessions#create'
    delete 'logout'         => 'sessions#destroy'
    get    'logout'         => 'sessions#destroy'
    resources :password_resets,
                            only: [:new, :create, :edit, :update]
    #get 'password_resets/new'
    #get 'password_resets/edit'

    # Food log
    get    'foodlog'        => 'food_entries#index'
    get    '/foodlog/:day'  => 'food_entries#index',
                                as: :food_log_day
    resources :food_entries,
                            only: [:index, :create, :update, :destroy]
    get     '/food_entries/delete/:id' =>
                                'food_entries#destroy',
                                as: :food_entry_delete
    get     '/food_entries/:day/log/:food_id' =>
                                'food_entries#log_food',
                                as: :food_entry_log_food
    post    '/food_entries/:day/log/:food_id' =>
                                'food_entries#add_food',
                                as: :food_entry_add_food


    # Foods
    get     '/foods/delete/:id' =>
                                'foods#destroy',
                                as: :food_delete
    get     '/foods/search/' => 'foods#search',
                                as: :food_search
    get     '/foods/q/' => 'foods#find',
                                as: :food_find
    get     '/foods/pull/:ndbno' => 'foods#pull',
                                as: :food_pull
    resources :foods,
                            only: [:new, :edit, :index, :show, :create, :update, :destroy]
end
