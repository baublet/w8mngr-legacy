module FoodsHelper

    require 'uri'
    require 'open-uri'

    def search_usda query, limit = 25, offset = 0
        api_key = 'yJ1LvSILRNHG5KiefXO6boHZqJOUkJ74bJNoNUz0'
        query = URI.encode(query)
        url = "http://api.nal.usda.gov/ndb/search/?format=json&q=#{query}&sort=n&max=#{limit.to_s}&offset=#{offset.to_s}&api_key=#{api_key}"

        response = make_api_request(url)

        if !response[0].present? && response["list"].present? && response["list"]["item"].present?
            return response["list"]["item"]
        else
            return []
        end
    end

    def get_usda_entry id
        api_key = 'yJ1LvSILRNHG5KiefXO6boHZqJOUkJ74bJNoNUz0'
        url = "http://api.nal.usda.gov/ndb/reports/?ndbno=#{id}&type=b&format=json&api_key=#{api_key}"

        response = make_api_request(url)

        if !response[0].present?
            return response["report"]["food"]
        else
            return []
        end
    end

    def make_api_request url
        begin
            response = open(url, :read_timeout => 5).read
        rescue OpenURI::HTTPError => e
            response = ActiveSupport::JSON.encode([:error => e.message])
        end
        return ActiveSupport::JSON.decode(response)
    end

    # Increments the popularity of food_id and measurement_id by 1
    # Fails silently if one or the other can't be found
    def increment_popularity food_id, measurement_id
        Food.increment_counter(:popularity, food_id.to_i)
        Measurement.increment_counter(:popularity, measurement_id.to_i)
    end

end
