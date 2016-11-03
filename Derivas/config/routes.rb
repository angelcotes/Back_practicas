Rails.application.routes.draw do
 
  get 'documents/create'

  get 'documents/show'

  get 'documents/destroy'

  get 'documents/index'

  get 'members/create'

  get 'members/update'

  get 'members/destroy'

  get 'members/index'

  mount_devise_token_auth_for 'User', at: 'auth'
 	post '/import', to: 'users#import'

  resources :users, only: :show do
  	member do
  		get 'activities'
  		get 'students'
  	end
  end

  get "/users/:user_id/courses/:course_id/students", to: 'users#student_courses'
  get "users/:user_id/courses", to: 'users#users_courses'
  get "users/:course_id/activitiesStudent", to: 'users#users_activities'
  get "users/:user_id/AllactivitiesStudent", to: 'users#users_all_activities'
  get "users/:user_id/AllGroups", to: 'users#users_all_groups'
  
  resources :courses, except: [:new, :edit] do 
    resources :students, except: [:new, :edit, :show]

    resources :activities, except: [:new, :edit] do
      resources :groups, except: [:new, :edit]
    end
  end
end