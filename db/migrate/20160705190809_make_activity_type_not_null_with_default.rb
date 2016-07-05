class MakeActivityTypeNotNullWithDefault < ActiveRecord::Migration
  def change
    change_column_default :activities, :activity_type, 0
    change_column_null :activities, :activity_type, false
  end
end
