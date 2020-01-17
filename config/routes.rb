Rails.application.routes.draw do
  root 'invoices#index'

  get    'login'   => 'sessions#new',      as: :login
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy',  as: :logout
  
  get "session/sso" => "sessions#sso"
  get "session/sso_login" => "sessions#sso_login"

  post 'test' => 'hooks#test'

  get  'taxes/get_defaults', to: 'taxes#get_defaults'

  resources :taxes, :templates, :series

  get "invoices/amounts"
  get "recurring_invoices/amounts"
  get "items/amount"

  resources :commons do
    post 'select_print_template', on: :member
  end
  
  resources :invoices do
    post 'bulk', on: :collection
    post 'select_print_template', on: :member
    get 'autocomplete', on: :collection
    get 'chart_data', on: :collection
    get 'send_email', on: :member
    get 'print', on: :member
    
    resources :payments
  end

  resources :recurring_invoices do
    post 'generate', on: :collection
    delete 'remove', on: :collection
    get 'chart_data', on: :collection
  end

  resources :customers do
    get 'autocomplete', on: :collection
    
    resources :invoices, only: [:index]
    resources :recurring_invoices, only: [:index]
  end
  
  resources :payment_receivers
  resources :payment_providers

  post 'templates/set_default', to: 'templates#set_default'
  post 'series/set_default', to: 'series#set_default'
  post 'taxes/set_default', to: 'taxes#set_default'

  get 'settings/global'
  put 'settings/global', to: 'settings#global_update'
  get 'settings/profile'
  put 'settings/profile', to: 'settings#profile_update'
  get 'settings/tags'
  put 'settings/tags', to: 'settings#tags_update'
  get 'settings/hooks'
  put 'settings/hooks', to: 'settings#hooks_update'
  get 'settings/api_token'
  post 'settings/api_token'
  get 'settings/payments'

  # API
  namespace :api do
    namespace :v1 do
      get 'invoices/print_template/:id/invoice/:invoice_id', to: 'commons#print_template', as: :rendered_template
      get 'stats', to: 'invoices#stats'
      resources :taxes, :series, only: [:index, :create, :show, :update, :destroy], defaults: { format: :json}
      resources :customers, only: [:index, :create, :show, :update, :destroy], defaults: { format: :json} do
        resources :invoices, only: [:index] # for filtering
      end
      resources :payments, only: [:show, :update, :destroy], defaults: {format: :json}
      resources :items, only: [:show, :update, :destroy], defaults: {format: :json} do
        resources :taxes, only: [:index], defaults: { format: :json}
      end

      resources :invoices, only: [:index, :create, :show, :update, :destroy, :send_email], defaults: { format: :json} do
        get 'send_email', on: :member
        resources :items, :payments, only: [:index, :create]
      end

      get 'recurring_invoices/generate_invoices', to: 'recurring_invoices#generate_invoices'
      resources :recurring_invoices, only: [:index, :create, :show, :update, :destroy], defaults: { format: :json} do
        resources :items, only: [:index, :create]
      end
    end
  end

  localized do
    resources :invoices, :recurring_invoices, :customers, :settings
  end
end
