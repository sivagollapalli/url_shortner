Rails.application.routes.draw do
  namespace 'api' do
    namespace :v1 do
      resources :users do
        collection do
          post 'sign_up'
          post 'sign_in'
        end
      end
      resources :short_urls
    end
  end
end
