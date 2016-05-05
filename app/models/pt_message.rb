# Saves the personal messages information generated from our Personal Trainer
# modules -- handles all of the duplication protection and seen information
# without the rest of the app having to worry about it

class PtMessage < ActiveRecord::Base
  belongs_to :user, inverse_of: :pt_messages

  # Because this is only used internally, we won't be using any validators

  # Moods indicate what type of message to show
    # 0 = Yellow, General warning (e.g., don't forget to log calories today!)
    # 1 = Green, positive, doing great (e.g., you're below your calories today, congrats!)
    # 2 = Red, somewhat negative, yet encouraging (e.g., you're over your calories today, but don't worry about one day; don't get yourself down)
    # 3 = Blue, encouraging, hasn't met goals in a while, but hopeful (e.g., you've been over your target calories every day this week, here are some tips to improve)
    # 4 = Pink, exciting, hooray (e.g., goal completed, birthday, faturday)
end