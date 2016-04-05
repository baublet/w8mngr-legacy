module Apis
  class USDA
    include HTTParty
    base_uri "api.nal.usda.gov"
    default_params  api_key:  "yJ1LvSILRNHG5KiefXO6boHZqJOUkJ74bJNoNUz0",
                    format:   "json",
                    sort:     "n"

    def initialize()
    end

    def search(options = {})
      return [] if options[:q].blank?
      options[:max] = (options[:max].blank?) ? 25 : options[:max]
      options[:offset] = (options[:offset].blank?) ? 0 : options[:offset]
      response = self.class.get('/ndb/search', { query: options })

      if !response[0].present? && response["list"].present? && response["list"]["item"].present?
        return response["list"]["item"]
      else
        return []
      end
    end

    def get_food id = 0
      id = id.to_i
      response = self.class.get("/ndb/reports", { query: { ndbno: id, type:b } })
      return response["report"]["food"]
    end
  end
end
