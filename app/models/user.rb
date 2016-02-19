class User < ActiveRecord::Base
	has_many :foodentries,	class_name: 'FoodEntry',
							foreign_key: 'user_id',
							dependent: :destroy
	has_many :foods,		class_name: 'Food',
							foreign_key: 'user_id'
							# dependent: :destroy
							# We want to keep all foods in the database whether the user exists anymore or not, so we can still search them

	attr_accessor :remember_token, :reset_token

	before_save {
		email.downcase!
		save_options
	}

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }

	# Returns a hash digest of the given string
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
													  BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Returns a random token
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# Sets the password reset attributes
	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	# Sends the actual password reset reminder
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	# Remembers the user
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Forgets a user (clears their cookies)
	def forget
		update_attribute(:remember_digest, nil)
	end

	# Returns true if the given token matches the digest
	def authenticated?(attribute, token)
		digest = self.send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	# Returns true if the user's password reset period has expired
	def password_reset_expired?
		return reset_sent_at < 2.hours.ago
	end

	def option
		if !@options.is_a?(Hash)
			options
		end
		@options
	end

	# Initializes user options
	def options
		# Populates the user options
		if @options.present?
			return @options
		else
			@options = {}
		end
		@option_values = OptionValue.where(user_id: self.id).all
		@option_info = Option.all
		@option_info.each do |info|
			if !@option_values.nil?
				#byebug
				user_has_set = @option_values.find { |var| var.option_id == info.id }
				if !user_has_set.nil?
					@options[info.name] = user_has_set.value
				else
					@options[info.name] = info.default_value
				end
			else
				@options[info.name] = info.default_value
			end
		end
	end

	def save_options
		# Only call this function if there are options being used here
		if !@options.is_a?(Hash)
			return true
		end

		# We need to reload our options in a test environment to make sure
		# our tests pasts. We don't do this in production because we won't be
		# adding and removing options on the fly like we will in tests.
		if Rails.env.test?
			@option_info = Option.all
			@option_values = OptionValue.where(user_id: self.id).all
		end

		# Loop through the options to add new values that differ from the default
		@options.each do |key, value|
			option = @option_info.find { |var| var.name == key }
			# Prevents developers from using options they haven't yet defined
			if !option.is_a?(Option)
				return false
			end
			if value != option.default_value
				# If the user has not set this option yet
				current = @option_values.nil? ? nil : @option_values.find { |var| var.option_id == option.id }
				if current.nil?
					# Then build it
					@option_values = @option_values.nil? ? [] : @option_values
					@option_values.push(OptionValue.new( option_id:  option.id,
													  	 user_id:	 self.id,
													  	 value:		 value
														)
										)
				else
					# Otherwise, just update it
					current.value = value
				end
			end
		end
		saved = true
		@option_values.each do |value_row|
			if !value_row.save
				saved = false
			end
		end
		return saved
	end
end
