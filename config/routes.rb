Rails.application.routes.draw do

  get 'home', to: 'home_page#index'

  root :to => 'sessions#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  get 'organization/:id/users', to: 'users#index'

  get 'organization/:id/projects', to: 'projects#index', as: "projects"
  get 'organization/:id/projects/new', to: 'projects#new', as: "new_project"
  post 'organization/:id/projects/new', to: 'projects#create'

  post 'project/:id', to: 'projects#generate_schedule', as: "generate_schedule"
  get 'project/:id/delete', to: 'projects#delete_schedule', as: "delete_schedule"
  post 'project/:id/delete', to: 'projects#destroy_schedule'

  get 'project/:id/human_resources', to: 'human_resources#index', as: "human_resources"
  get 'project/:id/human_resources/new', to: 'human_resources#new', as: "new_human_resource"
  post 'project/:id/human_resources/new', to: 'human_resources#create'

  get 'project/:id/tasks', to: 'tasks#index', as: "tasks"
  get 'project/:id/tasks/new', to: 'tasks#new', as: "new_task"
  post 'project/:id/tasks/new', to: 'tasks#create'

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
      get :view_schedule
      get :delete_schedule
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
