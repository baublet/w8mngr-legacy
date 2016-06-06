import LineChart from "../LineChart.vue"
import WeekInReview from "../WeekInReview.vue"
import UserStats from "../UserStats.vue"
require("../../utilities/strftime.js")

export default {
  el: "#dashboard-app",
  events: {
    "hook:ready": function() {
      console.log("Loading dashboard...")
      // Load our data from the rails app when the component is ready
      var app = this
      this.$dispatch('loading')
      this.$fetch({
        method: "GET",
        url: this.$fetchURI.dashboard.week_in_review,
        onSuccess: function(response) {
          app.weekCalories = app.MassageData(response.week_calories)
          app.weekDays = app.FormatDays(app.weekCalories)
          app.weekFat = app.MassageData(response.week_fat)
          app.weekCarbs = app.MassageData(response.week_carbs)
          app.weekProtein = app.MassageData(response.week_protein)
          app.weekWeights = app.MassageData(response.week_weights)
          // Iterate through the week averages and convert them to the desired
          // format. They often come as equations, so we need to compute them
          app.weekAverages = response.week_averages
          for (var key in app.weekAverages) {
            if(isNaN(app.weekAverages[key]) || !app.weekAverages[key]) app.weekAverages[key] = "-"
            else app.weekAverages[key] = parseInt(app.weekAverages[key], 10).toLocaleString()
          }
          // Format our week's macros
          app.macroPie = [parseInt(response.fat, 10),
                          parseInt(response.carbs, 10),
                          parseInt(response.protein, 10)]
          app.macroPieLabels = ["Fat", "Carbohydrates", "Protein"]
          app.$dispatch('notLoading')
          app.$broadcast('dataLoaded')
        },
      })
    },
    "loading": function() {
      this.loading = 1
    },
    "notLoading": function() {
      this.loading = 0
    },
  },
  computed: {
  },
  data: {
    loading: 1,
    weekAverages: {},
    weekDays: [],
    weekCalories: [],
    weekFat: [],
    weekCarbs: [],
    weekProtein: [],
    weekWeights: [],
    macroPie: [],
    macroPieLabels: [],
  },
  components: {
    LineChart,
    WeekInReview,
    UserStats,
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