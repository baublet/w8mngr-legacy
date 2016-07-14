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

  before_save :calculate_calories_burned

  include WeightManager::DayNavigator

  # Calculates the calories burned of this activity entry based on its type
  # For notes on this, see  https://github.com/baublet/w8mngr/issues/28
  def calculate_calories_burned
    type = activity.activity_type
    user_weight = user.recent_most_weight.value
    # Our global intensity multipler
    intensity = 1 + (activity.intensity / 10)

    case type

      when 0                                              # Weight lifting
        self.calories = 0 and return true if work == 0
        # Calculate the joules expended
        joules = (work / 1000) * 9.81 * 0.75
        # Calories per rep
        per_rep = (joules * 0.000239006) * 5
        # Multiplier for heart rate elevation and work intensity
        multiplier = 3.5 * (user_weight / work)
        # The full formula
        calories_burned = per_rep * reps * multiplier * intensity
        self.calories = calories_burned.round(2)

      when 1                                              # Timed things
        # Altering our intensity to work in the formula at
        # http://ask.metafilter.com/48652/Walking-formula
        intensity = intensity / 100
        intensity = intensity < 0.015 ? 0.015 : intensity
        # Convert user_weight to pounds from grams
        user_weight =  user_weight * 0.00220462
        # Work here will be time in seconds
        self.calories = intensity * user_weight * (work / 60)

      when 2                                              # Distance
        # Credit: NET calories burned per miles as listed at
        # https://www.checkyourmath.com/convert/length/miles_mm.php
        #
        # Find our intensity. Basic running is .65, walking is .3, sprinting is
        # all the way at .8
        intensity = intensity - 1
        intensity = intensity < 0.2 ? 0.2 : intensity
        intensity = intensity > 0.8 ? 0.8 : intensity
        # Convert their weight to pounds
        user_weight = user_weight * 0.00220462
        # Convert the unit of work from mm to miles
        work_in_miles = self.work * 0.00000062
        # And finally
        self.calories = intensity * user_weight * work_in_miles

      when 3                                              # Repetitions
        # A VERY simple and dirty calculation here. Basically, any of these reps
        # are going to be bodyweight, ranging from ridiculously easy for even the
        # most out of shape people (like a simple crunch), to something difficult
        # for even professional athletes (dragon flags). So we'll have a baseline
        # of 1 calorie, and range up to 6 per repetition depending on the exercise's
        # intensity
        intensity = (activity.intensity / 2).round
        intensity = intensity < 1 ? 1 : intensity
        self.calories = intensity * self.reps
      else

        self.calories = 0
    end
  end

  # Updates the activity entry's reps and work based on its type
  def convert_unit_for_save reps, work
    reps = reps.to_i
    work = work.downcase unless work.nil?
    type = activity.activity_type
    case type
    when 0                            # Weight lifting
      # If there's no unit attached, add their default one
      if (true if Float(work) rescue false)
        work = work + self.user.unit
      end
      # Converts the passed work units to grams (since we keep all weights in the DB as grams)
      work_g = work.to_unit.convert_to("g").scalar.to_i rescue false
      work_g = (work + current_user.unit).to_unit.convert_to("g").scalar.to_i rescue false if work_g == false
      unless work_g == false
        self.work = work_g
        return true
      end
      errors.add(:base, "Unable to parse the weight " + work)
    when 1                            # Time
      # Converts the passed work unit to seconds
      work = ChronicDuration.parse(work) rescue 0
      work = work.nil? ? 0 : work
      self.work = work
      return true
    when 2                            # Distance
      parsed_work = Unit.new(work) rescue nil
      # If it's nil, then Ruby Unit can't parse it, so let's try a quick parse ourselves for steps
      if parsed_work.nil?
        # Does the user specify steps?
        if work =~ /steps/i
          # Cool! Then let's find the number
          steps = /[0-9]+/.match(work)
          unless steps.nil?
            # Now, calculate the distance based on average stride data from
            stride = 74
            if self.user.preferences["height"].to_i > 0
              stride = 0.414 * self.user.preferences["height"].to_i
            end
            # Now multiply the steps by the height and we can get an approximate distance in cm, which we then convert to mm
            self.work = (stride * steps.to_s.to_i) * 10
            return true
          end
        end
      else
        self.work = parsed_work.convert_to("mm").scalar.to_i
        return true
      end
      errors.add(:base, "Unable to parse the distance " + work)
    when 3                            # Repetitions
      # Just make sure they pass in an integer
      self.reps = reps.to_i
      self.work = 0
      return true
    end
    errors.add(:base, "Invalid workout type... What gives?!")
    return false
  end

  # Returns the work expressed in the desired unit
  def work_in unit, from = "g"
    (work.to_s + from).to_unit.convert_to(unit).scalar.to_f
  end

  # Returns user_id's activity_id's last num (default: 1) days of entries with
  # the offset of offset (default: 1, so as to exclude today's entries). If you
  # pass day after offset, this function will return only entries before that
  # day (as an int YYYYMMDD).
  def self.recent_most (user_id, activity_id, num = 1, offset = 1, day = 30000000)
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
                            AND
                              day < :day
                          ORDER BY day DESC
                          LIMIT :num
                          OFFSET :offset
                        )
                  ORDER BY day DESC;",
                  {
                    num: num,
                    user_id: user_id,
                    activity_id: activity_id,
                    offset: offset,
                    day: day
                  }
                ]
    )
  end

end
