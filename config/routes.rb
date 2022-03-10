Rails.application.routes.draw do

  get 'home', to: 'home_page#index'

  root :to => 'sessions#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'log_out', to: 'sessions#destroy'

  patch 'users/:id/change_password', to: 'users#update_password'

  patch 'organization_users/new', to: 'organization_users#update_new'

  post 'projects/:id', to: 'projects#generate_schedule', as: "generate_schedule"
  delete 'projects/:id/delete_schedule', to: 'projects#destroy_schedule'

  patch 'tasks/:id/edit_precedences', to: 'tasks#update_precedences'

  post 'task_resources', to: 'task_resources#update_index'

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

  resources :organization_users, :except => [:show] do
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

  resources :human_resources, :except => [:show] do
    member do
      get :delete
    end
  end

  resources :task_resources, :except => [:show, :new, :create, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
