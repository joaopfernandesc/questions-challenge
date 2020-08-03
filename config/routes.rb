# frozen_string_literal: true
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/disciplines_accesses" => "disciplines#get_disciplines_accesses"
  get "/hottest_disciplines" => "disciplines#get_hottest_disciplines"

  resources :questions, only: [:index]
end
