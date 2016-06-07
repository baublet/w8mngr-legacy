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
    faturday: function(id) {
      id = (typeof id === "undefined") ? "" : parseInt(id, 10)
      return "/faturday/" + id
    },
    current_user: "/user",
    edit_profile: function(id) {
      return "/users/" + id + "/edit"
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
    },
    food_log_day: function(day) {
      return "/foodlog/" + day
    },
    dashboard: {
      week_in_review: "/dashboard",
      quarter_calories: "/data/food_entries/calories/week/52",
      quarter_weights:  "/data/weight_entries/week/52",
    },
  }
}