Rails.application.routes.draw do
	get "concerts/:id", to: "concerts#show"
end
