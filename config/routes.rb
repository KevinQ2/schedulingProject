Rails.application.routes.draw do

  get 'home', to: 'home_page#index'

  root :to => 'sessions#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  patch 'users/:id/change_password', to: 'users#update_password'

  patch 'organizations/reply/:id', to: 'organizations#member_reply', as: "member_reply"
  patch 'organization_members/leave/:id', to: 'organization_members#leave', as: "member_leave"

  get 'projects/generate_random', to: 'projects#generate_random', as: "generate_random_project"
  post 'projects/generate_random', to: 'projects#create_random'

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

  resources :schedules, :except => [:index, :new, :edit, :update] do
    member do
      get :delete
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
