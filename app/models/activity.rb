class Activity < ActiveRecord::Base

  # So that they're always sorted by those not deleted
  default_scope {
    where(deleted: false)
  }

  belongs_to :user, inverse_of: :activities

  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 4,  maximum: 96 }

end
