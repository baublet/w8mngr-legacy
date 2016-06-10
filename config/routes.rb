Rails.application.routes.draw do

    # Static pages
    root   "welcome#index"
    get    "/privacy"        =>  "welcome#privacy_policy"
    get    "/contact"        =>  "welcome#contact_form"
    get    "/getting_started"=>  "welcome#getting_started"
    get    "/terms_of_service"=> "welcome#terms_of_service"
    get    "/beta"           =>  "welcome#beta"

    # Users and sessions
    resources :users
    post   "/users/:id"     => "users#update"
    post   "/profile"        => "users#show"
    get    "/user"           => "users#show", as: :current_user
    get    "/signup"         => "users#new"
    get    "/login"          => "sessions#new"
    post   "/login"          => "sessions#create"
    delete "/logout"         => "sessions#destroy"
    get    "/logout"         => "sessions#destroy"
    resources :password_resets,only: [:new, :create, :edit, :update]

    # Food log
    get    "/foodlog"        => "food_entries#index"
    get    "/foodlog/:day"  => "food_entries#index",
                                as: :food_log_day
    resources :food_entries,    only: [:index, :create, :update, :destroy]
    get     "/food_entries/delete/:id" =>
                                "food_entries#destroy",
                                as: :food_entry_delete
    post    "/food_entries/:day/log/:measurement_id" =>
                                "food_entries#add_food",
                                as: :food_entry_add_food
    get     "/measurements/:id/chosen" => "measurements#increment_popularity"

    # Foods
    get     "/foods/:id/delete/" =>
                                "foods#destroy",
                                as: :food_delete
    get     "/foods/pull/(:ndbno)" => "usda#pull",
                                as: :food_pull
    resources :foods,           only: [:new, :edit, :index, :show, :create, :update, :destroy]

    # Faturdays
    get     "/faturday/:id(:format)"=>"faturday#create", as: :faturday_day
    get     "/faturday(:format)"=> "faturday#create", as: :faturday
    post    "/faturday(:format)"=> "faturday#create"

    # Foods and recipes search
    get     "/search/foods(:format)" => "search_foods#index",
                                as: :food_search
    get     "/search/recipes(:format)" => "search_foods#recipes",
                                as: :recipe_search

    # Weight entries
    resources :weight_entries,  only: [:index, :create, :update, :destroy]
    get     "/weightlog/"    => "weight_entries#index"
    get     "/weightlog/:day"=> "weight_entries#index",
                                as: :weight_log_day
    get     "/weightlog/:id/delete/" => "weight_entries#destroy",
                                as: :weight_entry_delete

    # Recipes and Ingredients
    resources :recipes do
      resources :ingredients, only: [:create, :update, :destroy]
    end
    get     "/recipes/:id/delete(.:format)" => "recipes#destroy",
                                as: :delete_recipe
    get     "/recipes/:recipe_id/ingredients/:id/delete(.:format)" => "ingredients#destroy",
                                as: :delete_recipe_ingredient
    post    "/recipes/:recipe_id/ingredients/add_measurement/:measurement_id" => "ingredients#create_from_food",
                                as: :add_food_to_recipe

    # Data points for big data
    get     "/data/food_entries/:column/:length_scope/:num(.:format)" =>
                                "food_entries_data#index",
                                as: :food_entries_data
    get     "/data/weight_entries/:length_scope/:num(.:format)" =>
                                "weight_entries_data#index",
                                as: :weight_entries_data

    # Onboarding routes for our get started wizard
    get     "/getstarted/register"  =>  "registrations#new",          as: :get_started
    post    "/getstarted/register"  =>  "registrations#create",       as: :get_started_create
    get     "/getstarted/calculate/"=>  "registrations#set_metrics",  as: :get_started_calculate
    post    "/getstarted/calculate" =>  "registrations#save_metrics", as: :get_started_calculate_save
    get     "/getstarted/target"    =>  "registrations#set_target",   as: :get_started_target
    post    "/getstarted/target"    =>  "registrations#save_target",  as: :get_started_target_save

    # Dashboard
    get     "/dashboard"            => "dashboard#index",             as: :dashboard
end
