module FoodsHelper
    require 'uri'
    require 'open-uri'

    def searchUSDA query
        api_key = 'yJ1LvSILRNHG5KiefXO6boHZqJOUkJ74bJNoNUz0'
        query = URI.encode(query)
        url = "http://api.nal.usda.gov/ndb/search/?format=json&q=#{query}&sort=n&max=25&offset=0&api_key=#{api_key}"

        response = makeAPIRequest(url)

        if !response[0].present? && response["list"].present? && response["list"]["item"].present?
            return response["list"]["item"]
        else
            return []
        end
    end

    def getUSDAEntry id
        api_key = 'yJ1LvSILRNHG5KiefXO6boHZqJOUkJ74bJNoNUz0'
        url = "http://api.nal.usda.gov/ndb/reports/?ndbno=#{id}&type=b&format=json&api_key=#{api_key}"

        response = makeAPIRequest(url)

        if !response[0].present?
            return response["report"]["food"]
        else
            return []
        end
    end

    def makeAPIRequest url
        begin
            response = open(url).read
        rescue OpenURI::HTTPError => e
            response = ActiveSupport::JSON.encode([:error => e.message])
        end
        return ActiveSupport::JSON.decode(response)
    end

end
