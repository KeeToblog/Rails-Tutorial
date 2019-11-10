Rails.application.routes.draw do
  get '/signup', to: 'users#new'

  # get 'static_pages/home'
  # get 'static_pages/help'
  get '/help', to: 'static_pages#help'
  # get 'static_pages/about'
  get '/about', to: 'static_pages#about'
  # get 'static_pages/contact'
  get '/contact', to: 'static_pages#contact'
  
  root 'static_pages#home'
end
