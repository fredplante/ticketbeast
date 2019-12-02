class ConcertsController < ApplicationController
	def show
		@concert = Concert.where.not(published_at: nil).find(params[:id])
	end

	rescue_from ActiveRecord::RecordNotFound do
		render file: "public/404.html", status: :not_found, layout: false
	end
end
