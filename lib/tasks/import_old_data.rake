desc "Imports data from the old database (in CSV format)"
task :import_old_data => :environment do

  require 'csv'
  require 'date'

  puts "Importing the users"

  # Wrap this all in a transaction
  ActiveRecord::Base.transaction do

    # we need to store the old User IDs to see where they correspond to new users
    old_user_ids = {}

    csv_text = File.read(Rails.root.join('db', 'import', 'users.csv'))
    csv = CSV.parse(csv_text, :headers => false)
    csv.each do |row|
      email = row[3]
      joined = DateTime.strptime(row[4],'%s')
      old_id = row[0].to_s
      user = User.new({
        email: email,
        password: User.new_token
      })
      if user.save
        user.update_attribute(:created_at, joined)
        old_user_ids[old_id] = user
        puts "Added user " + email
      else
        puts "Error adding user " + email + ". Rolling back transaction."
        raise ActiveRecord::Rollback
      end
    end

    # Load the weight entries
    csv_text = File.read(Rails.root.join('db', 'import', 'healthlog.csv'))
    csv = CSV.parse(csv_text, :headers => false)
    x = 0
    csv.each do |row|
      next if row[1].to_i != 1
      value = (row[2].to_i * 453.592).ceil
      user_id = row[6].to_s
      day = row[5].to_i
      if !old_user_ids[user_id].nil?
        new_entry = old_user_ids[user_id].weightentries.build({
          day: day,
          value: value
        })
        if new_entry.save
          x += 1
          puts "Imported weight entry " + x.to_s
        else
          puts "Error adding weight entry " + row[0]
          puts new_entry.inspect
          raise ActiveRecord::Rollback
        end
      else
        puts "Error adding entry " + row[0] + ". User " + user_id + " wasn't imported! Old user was probably deleted..."
      end
    end

    # Now, load all of the entries linking the user's old id with their new account id
    csv_text = File.read(Rails.root.join('db', 'import', 'entries.csv'))
    csv = CSV.parse(csv_text, :headers => false)
    x = 0
    csv.each do |row|
      day = row[2].to_i
      description = row[3]
      calories = row[4].to_i
      fat = row[6].to_i
      carbs = row[5].to_i
      protein = row[7].to_i
      user_id = row[8].to_s
      if !old_user_ids[user_id].nil?
        new_entry = old_user_ids[user_id].foodentries.build({
          day: day,
          description: description,
          calories: calories,
          fat: fat,
          carbs: carbs,
          protein: protein
        })
        if new_entry.save
          x += 1
          puts "Imported entry " + x.to_s
        else
          puts "Error adding entry " + row[0] + ". Ignoring..."
          #raise ActiveRecord::Rollback
        end
      else
        puts "Error adding entry " + row[0] + ". User " + user_id.to_s + " wasn't imported! Old user was probably deleted..."
        #raise ActiveRecord::Rollback
      end
    end

  end

end