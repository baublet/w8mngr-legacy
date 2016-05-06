module Apis
  class USDA
    include HTTParty
    base_uri "api.nal.usda.gov"
    default_params  api_key:  ENV["W8MNGR_API_KEY_USDA"],
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

    def get_food id = nil
      return nil if id.nil?
      response = self.class.get("/ndb/reports", { query: { ndbno: id, type: "b" } })
      return nil if response.nil?
      return nil if response["report"].nil?
      return response["report"]["food"]
    end
  end
end
