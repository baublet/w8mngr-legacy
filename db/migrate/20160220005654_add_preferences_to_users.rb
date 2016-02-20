class AddPreferencesToUsers < ActiveRecord::Migration
    def change
        add_column :users, :preferences, :hstore,  default: {:sex => "na"}, null: false
    end
end
