class ConvertMuscleTypeToBinary < ActiveRecord::Migration
  def change
    change_table :activities do |t|
                                        # 24 muscle groups max
      t.change :muscle_groups, :string, limit: 24, null: false, default: "000000000000000000000000"
    end
  end
end
