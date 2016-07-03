class Activity < ActiveRecord::Base
  belongs_to :user, inverse_of: :activities

  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 4,  maximum: 96 }

end
