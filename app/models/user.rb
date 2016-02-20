class User < ActiveRecord::Base
	has_many :foodentries,	class_name: 'FoodEntry',
							foreign_key: 'user_id',
							dependent: :destroy
	has_many :foods,		class_name: 'Food',
							foreign_key: 'user_id'
							# dependent: :destroy
							# We want to keep all foods in the database whether the user exists anymore or not, so we can still search them

	attr_accessor  :remember_token, :reset_token
	
	store_accessor :preferences
	validates_with UserPreferencesValidator

	before_save { email.downcase! }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
					  format: { with: VALID_EMAIL_REGEX },
					  uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

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

end
