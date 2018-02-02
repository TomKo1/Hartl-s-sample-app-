class UsersController < ApplicationController
	  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
	  before_action :correct_user, only: [:edit, :update]
	  before_action :admin_user,   only: :destroy		
	def index
		@users=User.where(activated: true).paginate(page: params[:page])
	end


	def new
		@user=User.new
	  end
	def show
		@user=User.find(params[:id])
		redirect_to root_url and return unless @user.activated?
	end

	def create
	    @user = User.new(user_params)
	    if @user.save
		#log_in @user
		#flash[:success]="Welcome to the Sample App!"
		#redirect_to @user
		@user.send_activation_email # sending activation email
		#UserMailer.account_activation(@user).deliver_now
		flash[:info]="Please check yuor email to activate your account."
		# now we redirect to the root URL instead of user site
		redirect_to root_url    
		else
	      render 'new'
	    end
	end

	def user_params
	      params.require(:user).permit(:name, :email, :password,
		                           :password_confirmation)
	end


	def edit 
	#	@user=User.find(params[:id])
	end
	

	 def update
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user

    else
      render 'edit'
    end
  end

	
    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
	store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

# COnfirms the correct user.
def correct_user
	@user=User.find(params[:id])
	redirect_to(root_url) unless current_user?(@user)
end


# deletes user if the usser issuing this action is and admin
def destroy
	User.find(params[:id]).destroy
	flash[:success]="User deleted"
	redirect_to users_url
end

# confirms an admin user.
def admin_user
	redirect_to(root_url) unless current_user.admin?
end

	
end
