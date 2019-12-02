class ConcertsController < ApplicationController
	def show
		@concert = Concert.where.not(published_at: nil).find(params[:id])
	end
end
