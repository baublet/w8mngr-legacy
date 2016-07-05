class Activity < ActiveRecord::Base

  # So that they're always sorted by those not deleted
  default_scope {
    where(deleted: false)
  }

  belongs_to :user, inverse_of: :activities

  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 4,  maximum: 96 }

  def muscle_group_values
    # Again, don't change the order of these. Only append to the end.
    [ :biceps,
      :deltoids,
      :forearms,
      :triceps,
      :trapezius,
      :lats,
      :abs,
      :obliques,
      :pectorals,
      :adductors,
      :calves,
      :hamstrings,
      :glutes,
      :quads
      ]
  end

  def targets_group? group
    index = muscle_group_values.index(group)
    return false if index.nil?
    return false if muscle_groups[index] ==  "0"
    return true
  end

  # Takes the array of muscle groups from params and formats it for our database
  def save_muscle_groups groups_array
    groups_array = {} unless groups_array.is_a?(Hash)
    self.muscle_groups = ""
    muscle_group_values.each do |name|
      bit = groups_array[name.to_s] == "1" ? "1" : "0"
      self.muscle_groups = self.muscle_groups + bit
    end
  end

  def activity_types display = false
    # Note: ONLY EVER append to this list. Do not splice.
    [:weight,             # reps and weight (e.g. 3 reps at 50lbs)
     :timed_high,         # timed, higher better (e.g., 60 second plank)
     :timed_low,          # timed, lower better (e.g., 7 minute-mile)
     :repetitive_high,    # for unassisted exercises, higher is better (e.g., push ups)
    ] if display == false
    # These should match the above, but be the display versions
    [ "Weight Lifting (weighted repititions)",
      "Timed Exercise (more time is better)",
      "Timed Exercise (less time is better)",
      "Repetitive Exercise (more repetitions are better)"
      ]
  end

  def type_name
    activity_types(true)[self.activity_type]
  end

end
