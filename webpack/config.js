// Our application configuration

module.exports = {
  regex: {
    foodlog_day: /foodlog\/(\d{8})/
  },
  resources: {
    base: "/",
    search_foods: function(q) {
      return "/search/foods/?q=" + q
    },
    foods: {
      pull: function(ndbno) {
        return "/foods/pull/" + ndbno
      },
      show: function(id) {
        return "/foods/" + id
      }
    },
    food_entries: {
      index: "/food_entries/",
      add: "/food_entries/",
      delete: function(id) {
        return "/food_entries/" + id
      },
      from_day: function(day) {
        return "/foodlog/" + day
      },
      update: function(id) {
        return "/food_entries/" + id
      }
    }
  }
}