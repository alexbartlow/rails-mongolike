Rails.application.routes.draw do
  resources :objects, constraints: {id: /.*/}
end
