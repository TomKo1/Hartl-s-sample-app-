class AccountActivationsController < ApplicationController

	def edit 
		user=User.find_by(email: params[:email])
		if user && !user.activated? && user.authenticated?(:activation, params[:id])
		   user.activate # change the content of database 
		   # we must update specific columns
		   user.update_attribute(:activated, true)
		   user.update_attribute(:activated_at, Time.zone.now)
		   # we log_in the user
		   log_in user
		   flash[:success]="Account activated!"
		   redirect_to user
		else
		  # now we handle the case when there is invalid activation token
		  flash[:danger]="Invalid activation link"
		  redirect_to root_url
	       end
	end

end
