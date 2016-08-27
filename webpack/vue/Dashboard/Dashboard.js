import LineChart from "../LineChart.vue"
import WeekInReview from "../WeekInReview.vue"
import UserStats from "../UserStats.vue"
import DonutChart from "../DonutChart.vue"
var strftime = require("strftime")

export default {
  el: "#dashboard-app",
  events: {
    "hook:ready": function() {
      this.$dispatch('loading')
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
          wir.weekDifferential = app.MassageData(response.week_differential)
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
      document.w8mngrLoading(true)
    },
    "notLoading": function() {
      document.w8mngrLoading(false)
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
    DonutChart,
  },
  methods: {
    MassageData: function(data) {
      if(!data.map) return
      return data.map(function(d) {
        return [d[0], (!d[1] ? '-': parseInt(d[1], 10).toLocaleString())]
      })
    },
    FormatDays: function(data) {
      var app = this
      return data.map(function(d) {
        var year, month, day, date, display, url
        year = parseInt(d[0].substring(0, 4), 10)
        month = parseInt(d[0].substring(5, 7), 10) - 1            // Because Javascript indexes months at 0...
        day = parseInt(d[0].substring(8, 10), 10)
        date = new Date(year, month, day)
        display = strftime('%A', date)
        //display = date.strftime('%A')
        console.log(year + "/" + month + "/" + day)
        url = app.$fetchURI.food_log_day(strftime('%Y%m%d', date))
        return [url, display]
      })
    },
  },
}