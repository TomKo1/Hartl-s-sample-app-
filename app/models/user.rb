class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token, :reset_token
 	before_save :downcase_email
	validates :name,  presence: true, length: { maximum: 50 }
    	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :email, presence: true, length: { maximum: 255 },
        format: { with: VALID_EMAIL_REGEX },
	uniqueness: { case_sensitive: false }

	validates :password, presence: true,length: { minimum: 6 }, allow_nil: true
	has_secure_password


	before_create :create_activation_digest # call create_Activation_digest before the user is created

	 # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end


	# Activates an account.
	def activate
	 # update_attribute(:activated, true)
	 # update_attribute(:activated_at, Time.zone.now)
	   update_columns(activated: true, activated_at: Time.zone.now)
	end

	# Sends activation email.
	def send_activation_email
	  UserMailer.account_activation(self).deliver_now
	end

	# Returns the hash digest of the given string
	def User.digest(string)
		    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    			BCrypt::Password.create(string, cost: cost)
	end	
	
	# Returns a random token
	def User.new_token
		SecureRandom.urlsafe_base64
	end

        # Sets the password reset attributes.
        def create_reste_digest
	   self.reset_token=User.new_token
           update_attribute(:reset_digest, User.digest(reset_token))
	   update_attribute(:reset_sent_at, Time.zone.now)
        end

        # Sends password reset email.
        def send_password_reset_email
	  UserMailer.password_reset(self).deliver_now        
	end

	# Rememebers a user in the database for use in persistent sessions.
	def remember
		self.remember_token=User.new_token	
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Returns true if the given token mathces the digest
	def authenticated?(attribute, token)
		digest=send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	# Forgets a user.
	def forget
		update_attribute(:remember_digest, nil)
	end

	private
	
	def create_activation_digest
		# Create the token and digest.
		self.activation_token=User.new_token
		self.activation_digest=User.digest(activation_token)
		# no need to use uppdate_attribute method as the user doesn't exist in the database
	end

	# downcases the email before saving to the database	
	def downcase_email
		#self.email=email.downcase	
		self.email.downcase!
	end

end
