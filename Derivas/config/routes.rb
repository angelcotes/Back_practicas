Rails.application.routes.draw do
 
  mount_devise_token_auth_for 'User', at: 'auth'
 
  resources :courses, except: [:new, :edit] do 
    resources :students, except: [:new, :edit, :show]

    resources :activities, except: [:new, :edit] do
      resources :groups, except: [:new, :edit]
    end
  end
end