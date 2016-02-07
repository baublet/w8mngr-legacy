Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

    root   'welcome#index'
    get    'privacy'        => 'welcome#privacy_policy'
    get    'contact'        => 'welcome#contact_form'
    get    'getting_started'=> 'welcome#getting_started'
    get    'terms_of_service'=> 'welcome#terms_of_service'

    get    'signup'         => 'users#new'
    get    'login'          => 'sessions#new'
    post   'login'          => 'sessions#create'
    delete 'logout'         => 'sessions#destroy'
    get    'logout'         => 'sessions#destroy'
    resources :password_resets,
                            only: [:new, :create, :edit, :update]

    get    'foodlog'        => 'food_entries#index'
    get    '/foodlog/:day'  => 'food_entries#index'

    resources :food_entries,
                            only: [:index, :create, :update, :destroy]
    get    '/food_entries/delete/:id' =>
                               'food_entries#destroy',
                            as: :food_entry_delete
    resources :users

end
