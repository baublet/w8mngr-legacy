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
          // Set the week in review  values
          var wir = {}
          wir.weekCalories = app.MassageData(response.week_calories)
          wir.weekDays = app.FormatDays(wir.weekCalories)
          wir.weekFat = app.MassageData(response.week_fat)
          wir.weekCarbs = app.MassageData(response.week_carbs)
          wir.weekProtein = app.MassageData(response.week_protein)
          wir.weekWeights = app.MassageData(response.week_weights)
          // Iterate through the week averages and convert them to the desired
          // format. They often come as equations, so we need to compute them
          wir.weekAverages = response.week_averages
          for (var key in wir.weekAverages) {
            if(isNaN(wir.weekAverages[key]) || !wir.weekAverages[key]) wir.weekAverages[key] = "-"
            else wir.weekAverages[key] = parseInt(wir.weekAverages[key], 10).toLocaleString()
          }
          app.$set('weekInReview', wir)

          // Format our week's macros
          app.macroPieLabels.$set(0, "Fat")
          app.macroPie.$set(0, parseInt(response.fat, 10))
          app.macroPieLabels.$set(1, "Carbs")
          app.macroPie.$set(1, parseInt(response.carbs, 10))
          app.macroPieLabels.$set(2, "Protein")
          app.macroPie.$set(2, parseInt(response.protein, 10))

          // Setup our UserStats object
          var userStats = {}
          userStats.tdee = response.tdee
          userStats.atdee = response.atdee
          userStats.firstWeight = response.first_weight
          userStats.firstWeightDate = response.first_weight_date
          userStats.lastWeight = response.last_weight
          userStats.lastWeightDate = response.last_weight_date
          userStats.minWeight = response.min_weight
          userStats.maxWeight = response.max_weight
          userStats.weightTimeDiff = response.first_last_difference
          app.$set('userStats', userStats)

          // Tell the rest of our elements that our data is now loaded
          app.$broadcast('dataLoaded')


          console.log("----------------------------Dashboard Data Loaded")
          app.$log()
          console.log(response)
          console.log("----------------------------\n\n")
          app.$dispatch('notLoading')
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
    weekInReview: {},
    macroPie: [],
    macroPieLabels: [],
    userStats: {},
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