# Saves the personal messages information generated from our Personal Trainer
# modules -- handles all of the duplication protection and seen information
# without the rest of the app having to worry about it

class PtMessage < ActiveRecord::Base
  belongs_to :user, inverse_of: :pt_messages

  # Because this is only used internally, we won't be using any validators
end