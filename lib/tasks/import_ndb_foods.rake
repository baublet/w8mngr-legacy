desc "Imports data from the old database (in CSV format)"
task :import_ndb_foods => :environment do

  # Get all of our foods
  puts "Preparing foods from FOOD_DES.txt...\n"
  foods = {}
  CSV.foreach(__dir__ + "/data/ndb/FOOD_DES.txt", {col_sep: "^", quote_char: "~", encoding: 'iso-8859-1:utf-8'}) do |row|
    foods[row[0]] = {
      ndbno: row[0],
      name: row[2],
      measurements: []
    }.stringify_keys
  end

  # Now, load our Nutritional Data into memory in the form of:
  # nutrition[ndbno(string)][calories|fat|carbs|protein]
  puts "Preparing nutrition from NUT_DATA.txt...\n"
  nutrition = {}

  # We're looking for specific nutrient IDs for each item
  macros = {
      "208": "calories",
      "204": "fat",
      "205": "carbs",
      "203": "protein"
  }.stringify_keys

  CSV.foreach(__dir__ + "/data/ndb/NUT_DATA.txt", col_sep: "^", quote_char: "~") do |row|
    # Skip this if it isn't one of our big 4
    next if [203, 204, 205, 208].include? row[1]
    # Create the row if it's not yet made
    nutrition[row[0]] = {} if nutrition[row[0]].nil?
    # Add this macro to it
    # The way the USDA saves the data is per 100g, and the weights file just gives
    # it a multiplier (from 1 gram, which is why we do the math here)
    nutrition[row[0]][macros[row[1].to_s]] = row[2].to_f / 100
  end

  # Now, load the weights into memory in the format:
  # weights[ndbno][] = { amount, unit, multiplier }
  puts "Preparing weights from WEIGHT.txt...\n"
  weights = {}
  CSV.foreach(__dir__ + "/data/ndb/WEIGHT.txt", col_sep: "^", quote_char: "~", encoding: 'iso-8859-1:utf-8') do |row|
    weights[row[0]] = [] if weights[row[0]].nil?
    weights[row[0]] << {
      amount: row[2],
      unit: row[3],
      multiplier: row[4].to_f
    }.stringify_keys
  end

  # Now, everything's loaded, let's assemble the entries into an easy-to-iterate
  # array
  puts "Merging data...\n"
  weights.each_pair do |ndbno, weight_list|
    weight_list.each do |data|
      foods[ndbno]["measurements"] << {
        amount: data["amount"],
        unit: data["unit"],
        calories: (data["multiplier"] * nutrition[ndbno]["calories"]).to_i,
        fat:      (data["multiplier"] * nutrition[ndbno]["fat"]).to_i,
        carbs:    (data["multiplier"] * nutrition[ndbno]["carbs"]).to_i,
        protein:  (data["multiplier"] * nutrition[ndbno]["protein"]).to_i
      }.stringify_keys
    end
  end

  # Finally, remove all of the entries which don't have measurements
  puts "Removing foods without measurements...\n"
  foods = foods.delete_if { |key, food| food["measurements"].count == 0 }

  # Wrap this all in a transaction
  total_foods = 0
  total_measurements = 0
  ActiveRecord::Base.transaction do

    # Put everything under our first user, me :)
    user = User.first

    # Loop through our numbers and add them to our database. If they're already
    # added, just update the name and measurements
    foods.each_pair do |ndbno, report|

      total_foods = total_foods + 1

      # NB: Commented the below out because we don't grab this information from
      # the API anymore, but from local data.
      # Grab the report
      # report = usda.get_food ndbno

      if report.nil?
        puts "Failed to grab report for " + ndbno + "...\n"
        next
      end

      # First, search for the NDB number
      food = Food.where(ndbno: ndbno).first

      puts "Processing " + report["name"] + "\n"

      #byebug

      if food.nil?

        # Make a new food for this item
        food = user.foods.new(
          ndbno: ndbno,
          name: report["name"],
          description: report["description"]
        )
        report["measurements"].each do |measurement|
          total_measurements = total_measurements + 1
          food.measurements.new(
            amount: measurement["amount"],
            unit: measurement["unit"],
            calories: measurement["calories"],
            fat: measurement["fat"],
            carbs: measurement["carbs"],
            protein: measurement["protein"]
          )
        end

        food.save
        puts " - Added it and " + report["measurements"].count.to_s + " measurements\n"

      else

        # Make sure this food has the appropriate/correct measurements
        report["measurements"].each do |measurement|
          total_measurements = total_measurements + 1
          # Get the current measurement as it exists on the food
          existing_measurement = Measurement.where(food_id: food.id, unit: measurement["unit"]).first
          if existing_measurement.nil?
            # Can't find this measurement in the food? Add it
            food.measurements.build(
              amount: measurement["amount"],
              unit: measurement["unit"],
              calories: measurement["calories"],
              fat: measurement["fat"],
              carbs: measurement["carbs"],
              protein: measurement["protein"]
            ).save
            food.save
            puts " - Added missing measurement " + measurement["unit"] + "\n"
          else
            existing_measurement.amount = measurement["amount"]
            existing_measurement.unit = measurement["unit"]
            existing_measurement.calories = measurement["calories"]
            existing_measurement.fat = measurement["fat"]
            existing_measurement.carbs = measurement["carbs"]
            existing_measurement.protein = measurement["protein"]
            existing_measurement.save
            puts " - Updated measurement " + measurement["unit"] + "\n"
          end

        end
      end

    end

    puts "\nProcessed a total of " + total_foods.to_s + " foods and " + total_measurements.to_s + " measurements!\n\n"

  end
end