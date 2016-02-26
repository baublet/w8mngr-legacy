class User < ActiveRecord::Base
	has_many :foodentries,	class_name: "FoodEntry",
							foreign_key: "user_id",
							dependent: :destroy,
							inverse_of: :user
	has_many :foods,		class_name: "Food",
							foreign_key: "user_id",
							inverse_of: :user
	has_many :weightentries,class_name: "WeightEntry",
							dependent: :destroy,
							inverse_of: :user

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

	def food_totals day = nil
		day = day.nil? ? current_day : day
		entries = foodentries_from(day)
		totals = {calories: 0, fat: 0, carbs: 0, protein: 0}
		totals["calories"] = entries.map{|f| f["calories"]}.compact.reduce(0, :+)
		totals["fat"] = entries.map{|f| f["fat"]}.compact.reduce(0, :+)
		totals["carbs"] = entries.map{|f| f["carbs"]}.compact.reduce(0, :+)
		totals["protein"] = entries.map{|f| f["protein"]}.compact.reduce(0, :+)
		return totals
	end

	def foodentries_from day
		foodentries.where(day: day) || foodentries.none
	end

	def weight_average day = nil
		day = day.nil? ? current_day : day
		entries = weightentries_from day
		begin
			average = (entries.map{|e| e["value"]}.compact.reduce(0, :+) / entries.compact.size).to_i || 0
		rescue
			average = 0
		end
		average
	end

	def weightentries_from day
		weightentries.where(day: day) || weightentries.none
	end

	# Returns a string representation of their sex
	def sex
		if preferences["sex"] == "m"
			"Male"
		elsif preferences["sex"] == "f"
			"Female"
		else
			"Other / Prefer not to disclose"
		end
	end

	# Returns the user's age
	def age
		dob = Chronic.parse(preferences["birthday"])
		now = Time.now.utc.to_date
  		now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
	end

	# Returns the user's name if it's set, or the email if it isn't
	def name
		preferences["name"].blank? ? email : preferences["name"]
	end

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
