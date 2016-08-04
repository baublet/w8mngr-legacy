module Apis
  class USDA
    include HTTParty
    default_timeout 3
    base_uri "api.nal.usda.gov"
    default_params  format:   "jason",
                    #api_key:  ENV["W8MNGR_API_KEY_USDA"],
                    api_key:  "s3Q1Yc3kNEfdvz9t2WWRyoNFZ9N2IIvklejXy2Ur",
                    sort:     "n"

    def initialize()
    end

    def search(options = {})
      return [] if options[:q].blank?
      options[:max] = (options[:max].blank?) ? 25 : options[:max]
      options[:offset] = (options[:offset].blank?) ? 0 : options[:offset]
      begin
        response = self.class.get('/ndb/search', { query: options })

        if !response[0].present? && response["list"].present? && response["list"]["item"].present?
          return response["list"]["item"]
        else
          return []
        end
      rescue
        return []
      end
    end

    def get_food id = nil
      return nil if id.nil?

      begin
        response = self.class.get("/ndb/reports", { query: { ndbno: id, type: "f" } })
      rescue
        return nil
      end

      return nil if response.nil?
      return nil if response["report"].nil?

      # Now, we want to heavily filter this junk so that it only contains the data
      # we want in the format we want, like this:
      # report = {
      #  ndbno
      #  name
      #  description (fg)
      #  measurements[] = {
      #    amount
      #    unit
      #    calories
      #    fat
      #    carbs
      #    protein
      #  }
      # }

      r = response["report"]["food"]
      report = {
        "ndbno": r["ndbno"],
        "name": r["name"],
        "description": r["fg"],
        "measurements": []
      }
      # We're looking for specific nutrient IDs for each item
      # 208 = Calories
      # 204 = Fat
      # 205 = Carbs
      # 203 = Protein
      valid_ids = [ 203,       204,   205,     208]
      keys =      ["protein", "fat", "carbs", "calories"]
      measurements = {}
      r["nutrients"].each do |nutrient|
        next unless valid_ids.include?(nutrient["nutrient_id"])
        nutrient["measures"].each do |measurement|
          next if measurement.nil?
          # Set the measurement basics here
          key = measurement["qty"].to_s + measurement["label"]
          # If this measurement isn't here, yet, create it!
          measurements[key] = {} if measurements.try(:[], key).nil?
          # Set the name and unit
          measurements[key]["amount"] = measurement["qty"]
          measurements[key]["unit"] = measurement["label"]
          # Set the specific macro
          macro = valid_ids.index(nutrient["nutrient_id"])
          measurements[key][keys[macro]] = nutrient["value"]
        end
      end

      # Add them to our main report as an array
      measurements.each_value { |item| report[:measurements] << item }

      return report.stringify_keys
    end

    # Fetches a complete list of the foods from the NDB database and returns it
    # as an array of strings (that represent NDB numbers)
    #
    # This uses several get requests and is SLOW, so don't do this on user-facing
    # methods...
    def get_all_ndbnos
      puts "Fetching all NDB numbers...\n\n"
      ndbnos = []
      begin
        # We manually break this loop because we never make assumptions about how
        # big the NDB list is
        offset = 0
        i = 0
        max = 250
        while 1
          puts "Querying the NDB -- " + i.to_s + "\n"
          response = self.class.get "/ndb/list", {
              query: {
                lt: "f",
                max: max,
                offset: offset,
              }
            }
            # No responses? We're at the end!
            break if response["list"]["total"] == 0
            # Responses, so add them all to our ndbnos database
            ndbnos.concat(response["list"]["item"].map { |item| item["id"] })
            offset = offset + 250
            i = i + 1
        end
      rescue
        # Something went wrong! Typically, this is nothing, but let the user know
        puts "\n\nHmm... something went wrong when querying NDB IDs...\n\n"
      end
      ndbnos = ndbnos.uniq
      puts "\n\nFound " + ndbnos.count.to_s + " IDs..."
      return ndbnos
    end
  end
end
