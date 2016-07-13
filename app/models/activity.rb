class Activity < ActiveRecord::Base

  # So that they're always sorted by those not deleted
  default_scope {
    where(deleted: false)
  }

  belongs_to :user, inverse_of: :activities
  has_many :activity_entries, inverse_of: :activities

  validates :user_id, presence: true
  validates :name, presence: true, length: { minimum: 4,  maximum: 96 }

  include PgSearch
  pg_search_scope :search_activities,
                      :against => {
                          :name => 'A',
                          :description => 'B'
                      },
                      :ranked_by => "(popularity * 0.1) + :tsearch",
                      :using => {
                          :tsearch => {
                              :prefix => true,
                              :negation => true,
                              :dictionary => "english"
                          }
                      }

  # NOTE: Don't change the order of these. Only append to the end.
  MUSCLE_GROUP_VALUES =     [ :biceps,
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

  # Returns num number of ActivityEntries for this activity for user_id. Specify
  # offset as 1 to exclude the first offset number of days
  def entries user_id, num = 1, offset = 0, day = 30000000
    ActivityEntry.recent_most user_id, self.id, num, offset, day
  end

  # Returns true if this activity targets the muscle group passed, otherwise false
  def targets_group? group
    index = Activity::MUSCLE_GROUP_VALUES.index(group)
    return false if index.nil?
    return false if muscle_groups[index] ==  "0"
    return true
  end

  # Returns true if this activity has any muscle groups targeted, otherwise false
  def targets_any_group?
    self.muscle_groups.each_char do |c|
      return true if c == "1"
    end
    return false
  end

  # Takes the array of muscle groups from params and formats it for our database
  def update_muscle_groups groups
    groups = {} unless groups.is_a?(Hash)
    groups.symbolize_keys
    self.muscle_groups = ""
    Activity::MUSCLE_GROUP_VALUES.each do |name|
      bit = groups[name] == "1" ? "1" : "0"
      self.muscle_groups = self.muscle_groups + bit
    end
  end

  # Returns the LIKE column search string for querying the database based on
  # muscle groups targeted. For instance, if you want to search for only activities
  # that target biceps:
  #
  # muscle_groups_like {biceps: 1}
  #                                 =>    "1____________%"
  #
  # We then use this to query the column for muscle_groups LIKE "1____________%"
  def self.muscle_groups_like groups
    groups = {} unless groups.is_a?(Hash)
    groups.symbolize_keys
    like_string = ""
    self::MUSCLE_GROUP_VALUES.each do |name|
      bit = groups[name].nil? ? "_": groups[name].to_s[0]
      like_string = like_string + bit
    end
    return like_string + "%"
  end

  def activity_types disp = false
    # Note: ONLY EVER append to this list. Do not splice.
    return [ :weight,             # reps and weight (e.g. 3 reps at 50lbs)
             :timed,              # timed (e.g., 20 minutes running)
             :distance,           # distance exercises (e.g., 5 miles)
             :repetitive_high,    # for unassisted exercises, higher is better (e.g., push ups)
            ] if disp == false
    # These should match the above, but be the display versions
    return [  "Weightlifting (e.g., squats, bench press)",
              "Timed Exercise (e.g., walking, planks, wall-sits)",
              "Distance Exercise (e.g., running, biking)",
              "Repetitive Exercise (e.g., push ups, bodyweight squats)"
              ]
  end

  # Returns a readable name of the activity_type
  def type_name
    activity_types(true)[self.activity_type]
  end

  # Returns the partial name of the activity_type
  def type_template
    activity_types(false)[self.activity_type].to_s
  end

end
