Rails.application.routes.draw do

  mount_devise_token_auth_for 'User', at: 'auth'
 	post '/import', to: 'users#import'
  post "users/:user_id/members", to: 'users#enroll_member'
  post "users/:user_id/group/:group_id/documents", to: 'users#save_document'

  resources :users, only: :show do
  	member do
  		get 'activities'
  		get 'students'
      put 'startActivity'
      get 'allGroupStudent'
  	end
  end

  delete "users/:document_id/document", to: 'users#deleteDocument'

  get "users/:group_id/members", to: 'users#membersGroup'
  get "users/:user_id/groupStudent/:activity_id", to: 'users#groupStudent'
  get "/users/:user_id/courses/:course_id/students", to: 'users#student_courses'
  get "users/:user_id/courses", to: 'users#users_courses'
  get "users/:course_id/activitiesStudent", to: 'users#users_activities'
  get "users/:user_id/AllactivitiesStudent", to: 'users#users_all_activities'
  get "users/:user_id/AllGroups", to: 'users#users_all_groups'
  get "users/:user_id/course/:course_id/group/:group_id/members", to: 'users#members_group'

  resources :courses, except: [:new, :edit] do
    resources :students, except: [:new, :edit, :show]

    resources :activities, except: [:new, :edit] do
      resources :groups, except: [:new, :edit]
    end
  end

  # Path to uploads files
  get 'storage/uploads/document/address/:id/:basename.:extension', to: 'documents#download'
end
