class Routine < ActiveRecord::Base
  belongs_to :user, inverse_of: :routines

  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 4, maximum: 96 }

  attr_accessor :last_completed

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

  # Returns the last day this routine was fully completed
  def last_completed
    @last_completed ||= ActivityEntry.
        select(:day).distinct.
        where(user_id: user_id).
        where(activity_id: activities).
        group(:day).
        having("count(DISTINCT activity_id) = ?", activities.count).
        order("day DESC").
        try(:[], 0).
        try(:day)
  end

end
