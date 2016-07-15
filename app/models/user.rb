class User < ActiveRecord::Base

  has_many :foodentries, class_name: "FoodEntry",
              foreign_key: "user_id",
              dependent: :destroy,
              inverse_of: :user

  has_many :foods, class_name: "Food",
              foreign_key: "user_id",
              inverse_of: :user

  has_many :weightentries, class_name: "WeightEntry",
              dependent: :destroy,
              inverse_of: :user

  has_many :recipes, class_name: "Recipe",
              dependent: :destroy,
              inverse_of: :user

  has_many :pt_messages, class_name: "PtMessage",
              dependent: :destroy,
              inverse_of: :user

  has_many :activities, class_name: "Activity",
              inverse_of: :user

  has_many :activity_entries, class_name: "ActivityEntry",
              inverse_of: :user

  has_many :routines, class_name: "Routine",
              inverse_of: :user

  attr_accessor  :remember_token, :reset_token

  before_save { email.downcase! }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Our Personal Trainer messages concern, located in ./concerns
  include UserPtMessages
  # Our preferences concern
  include UserPreferences
  # For loading food, weight, training, etc log days (shorthand loaders and stuff)
  include UserHealthFunctions

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

  # Queues up the password reset job to send the user their email
  def reset_password
    # We do this in here, rather than in the job so we can test both this
    # and the jobs in integration tests. If the job does it, the token gets
    # discarded and we can't do functional testing with it
    create_reset_digest
    SendPasswordResetMessageJob.perform_now self.id, self.reset_token
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

  # Returns the user's avatar image
  # TODO
  def avatar
    false
  end

end
