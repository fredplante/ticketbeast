Rails.application.routes.draw do
	get "concerts/:id", to: "concerts#show"
	post "concerts/:concert_id/orders", to: "concert/orders#create"
	get "orders/:confirmation_number", to: "orders#show"
end
