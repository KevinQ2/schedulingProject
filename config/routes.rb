Rails.application.routes.draw do

  get 'home', to: 'home_page#index'

  root :to => 'sessions#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  get 'organization/:id/users', to: 'users#index'

  get 'organization/:id/projects', to: 'projects#index'
  get 'organization/:id/projects/new', to: 'projects#new'
  post 'organization/:id/projects/new', to: 'projects#create', as: "projects"

  get 'project/:id/human_resources', to: 'human_resources#index'
  get 'project/:id/human_resources/new', to: 'human_resources#new'
  post 'project/:id/human_resources/new', to: 'human_resources#create', as: "human_resources"

  get 'project/:id/tasks', to: 'tasks#index'
  get 'project/:id/tasks/new', to: 'tasks#new'
  post 'project/:id/tasks/new', to: 'tasks#create', as: "tasks"

  resources :users, :except => [:index] do
    member do
      get :delete
    end
  end

  resources :organizations do
    member do
      get :delete
    end
  end

  resources :organization_users do
    member do
      get :delete
    end
  end

  resources :projects, :except => [:index, :new, :create]  do
    member do
      get :delete
      get :schedule
    end
  end

  resources :tasks, :except => [:index, :new, :create]  do
    member do
      get :delete
    end
  end

  resources :human_resources, :except => [:index, :new, :create]  do
    member do
      get :delete
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
