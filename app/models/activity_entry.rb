class ActivityEntry < ActiveRecord::Base
  belongs_to :activity,   inverse_of: :activity_entries
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

  # Returns the work expressed in the desired unit
  def work_in unit
    (work.to_s + "g").to_unit.convert_to(unit).scalar.to_f
  end

  # Returns user_id's activity_id's last num (default: 1) days of entries with
  # the offset of offset (default: 1, so as to exclude today's entries)
  def self.recent_most (user_id, activity_id, num = 1, offset = 1)
    find_by_sql(["SELECT *
                  FROM activity_entries
                  WHERE
                      user_id = :user_id
                    AND
                      activity_id = :activity_id
                    AND
                      day IN
                        ( SELECT DISTINCT day
                          FROM activity_entries
                          WHERE
                              user_id = :user_id
                            AND
                              activity_id = :activity_id
                          ORDER BY day DESC
                          LIMIT :num
                          OFFSET :offset
                        )
                  ORDER BY day DESC;",
                  {
                    num: num,
                    user_id: user_id,
                    activity_id: activity_id,
                    offset: offset
                  }
                ]
    )
  end

end
