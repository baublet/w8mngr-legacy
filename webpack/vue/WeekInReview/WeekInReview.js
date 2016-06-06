require("../../utilities/strftime.js")

export default {
  props: [
    "chart",
  ],
  data: function() {
    return {
      week_averages: {},
      week_calories: {},
      week_fat: {},
      week_carbs: {},
      week_protein: {},
      week_weights: {},
      week_days: {},
    }
  },
  events: {
    'hook:ready': function() {
      // Load our data from the rails app when the component is ready
      var app = this
      this.$dispatch('loading')
      this.$fetch({
        method: "GET",
        url: this.$fetchURI.dashboard.week_in_review,
        onSuccess: function(response) {
          app.week_calories = app.MassageData(response.week_calories)
          app.week_days = app.FormatDays(app.week_calories)
          app.week_fat = app.MassageData(response.week_fat)
          app.week_carbs = app.MassageData(response.week_carbs)
          app.week_protein = app.MassageData(response.week_protein)
          app.week_weights = app.MassageData(response.week_weights)
          // Iterate through the week averages and convert them to the desired
          // format. They often come as equations, so we need to compute them
          app.week_averages = response.week_averages
          for (var key in app.week_averages) {
            if(isNaN(app.week_averages[key]) || !app.week_averages[key]) app.week_averages[key] = "-"
            else app.week_averages[key] = parseInt(app.week_averages[key], 10).toLocaleString()
          }
          app.$dispatch('notLoading')
        },
      })
    },
  },
  methods: {
    MassageData: function(data) {
      return data.map(function(d) {
        return [d[0], (!d[1] ? '-': parseInt(d[1], 10).toLocaleString())]
      })
    },
    FormatDays: function(data) {
      var app = this
      return data.map(function(d) {
        var display = new Date(d[0]).strftime('%A')
        var url = app.$fetchURI.food_log_day(new Date(d[0]).strftime('%Y%m%d'))
        return [url, display]
      })
    },
  },
}