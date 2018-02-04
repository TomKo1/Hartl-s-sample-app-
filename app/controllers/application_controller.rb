class ApplicationController < ActionController::Base
  	protect_from_forgery with: :exception
	
	def hello
		render html: "hello, world!"
	end
	include SessionsHelper # we arrange to make
	# sessions helpers available on all our controllers

	private 

	# Confirms a logged-in user.
	def logged_in_user
		unless logged_in?
			store_location
			flash[:danger]="Please log in."
			redirect_to login_url
		end
	end


end
