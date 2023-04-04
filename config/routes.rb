Diary::Engine.routes.draw do
  resources :calendar_entries do
    get :subscribe, on: :collection
  end
end
