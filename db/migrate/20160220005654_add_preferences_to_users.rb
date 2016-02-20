class AddPreferencesToUsers < ActiveRecord::Migration
    def change
        add_column :users, :preferences, :hstore,  default: {}, null: false
    end
end
