class Routine < ActiveRecord::Base
  belongs_to :user, inverse_of: :routines

  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 4, maximum: 96 }

  # Returns the progress in the form of an array of this routine based on the
  # current day.
  #
  # Return
  # [completed_activities, total_activities]
  def progress day
    activities_completed = ActivityEntry.
                                  where(day: day).
                                  where(activity_id: activities).
                                  distinct.
                                  where(user_id: user_id).
                                  count(:activity_id)
    return [activities_completed, activities.count]
  end

end
