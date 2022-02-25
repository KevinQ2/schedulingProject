Rails.application.routes.draw do

  get 'organization_users/index'
  get 'organization_users/new'
  get 'organization_users/show'
  get 'organization_users/edit'
  get 'organization_users/delete'
  get 'organization_user/index'
  get 'organization_user/new'
  get 'organization_user/show'
  get 'organization_user/edit'
  get 'organization_user/delete'
  get 'home', to: 'home_page#index'

  root :to => 'sessions#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  get 'organization/:id/users', to: 'users#index'

  post 'project/:id', to: 'projects#generate_schedule', as: "generate_schedule"
  get 'project/:id/delete', to: 'projects#delete_schedule', as: "delete_schedule"
  post 'project/:id/delete', to: 'projects#destroy_schedule'

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

  resources :projects do
    member do
      get :delete
      get :view_schedule
      get :delete_schedule
    end
  end

  resources :tasks do
    member do
      get :delete
    end
  end

  resources :human_resources do
    member do
      get :delete
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
