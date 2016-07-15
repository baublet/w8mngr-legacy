class DropRoutineCompletionsTable < ActiveRecord::Migration
  def change
    drop_table :routine_completions
  end
end
