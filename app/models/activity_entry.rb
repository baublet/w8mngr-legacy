class ActivityEntry < ActiveRecord::Base
  belongs_to :activity
  belongs_to :user,       inverse_of: :activity_entries
  belongs_to :routine

  validates :user_id,     presence: true
  validates :activity_id, presence: true
  validates :day,         presence: true, numericality: { only_integer: true, greater_than: 19850501, less_than: 20850501 }
  # Our column called `work` is a general column of things like seconds, weight
  # moved, laps, etc. We always have this column as a number, but our activity
  # model helpers help us format the number into something that makes sense
  # depending on the activity type. Side note: we have a `reps` column as a shorter
  # numeric that allows certain activities to enter extra info. Weightlifting,
  # for example, will have both reps and weight, so we need both `reps` and `work`
  validates :work,        presence: true

  include WeightManager::DayNavigator

end
