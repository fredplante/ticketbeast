class ConcertsController < ApplicationController
	def show
		@concert = Concert.find(params[:id])
	end
end