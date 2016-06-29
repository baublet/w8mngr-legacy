class ActivityEntry < ActiveRecord::Base
  belongs_to :activity
  belongs_to :user
  belongs_to :routine
end
