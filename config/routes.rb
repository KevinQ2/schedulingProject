Rails.application.routes.draw do

  get 'home', to: 'home_page#index'

  root :to => 'sessions#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  patch 'users/:id/change_password', to: 'users#update_password'

  get 'projects/generate_random', to: 'projects#generate_random', as: "generate_random_project"
  post 'projects/generate_random', to: 'projects#create_random'
  post 'projects/:id', to: 'projects#generate_schedule', as: "generate_schedule"
  delete 'projects/:id/delete_schedule', to: 'projects#destroy_schedule'

  patch 'projects/:id', to: 'projects#compare_algorithms', as: "compare_algorithms"

  patch 'tasks/:id/edit_precedences', to: 'tasks#update_precedences'

  resources :users, :except => [:index] do
    member do
      get :delete
      get :change_password
    end
  end

  resources :organizations do
    member do
      get :delete
    end
  end

  resources :organization_members, :except => [:show] do
    member do
      get :delete
    end
  end

  resources :projects, :except => [:index] do
    member do
      get :delete
      get :view_schedule
      get :delete_schedule
    end
  end

  resources :tasks, :except => [:show] do
    member do
      get :delete
      get :edit_precedences
    end
  end

  resources :teams, :except => [:show] do
    member do
      get :delete
    end
  end

  resources :potential_allocations, :except => [:show, :new, :create, :destroy]

  resources :schedules, :except => [:index, :new, :create, :edit, :update, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
