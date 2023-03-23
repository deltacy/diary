Rails.application.routes.draw do
  mount Diary::Engine => "/diary"
end
