var Chart = require("chart.js")

// This is our food-entry item component, slim and easy to understand
export default {
  props: [
    "chart",
  ],
  data: function() {
    return {
      loadingData: 0,
      data: [],
      chartObject: null,
      requestedData: [],
    }
  },
  events: {
    'hook:ready': function() {
      switch (this.chart) {
        case "quarter-calories":
          this.loadQuarterCalories()
          break
      }
    },
  },
  methods: {
    loadData: function(uris, callback) {
      this.loadingData = 0
      this.requestedData = []
      if (typeof uris !== "array") uris = [uris]
      console.log("Loading line chart data from URIs:")
      console.log(uris)
      var app = this
      for(var i = 0; i < uris.length; i++) {
        this.loadingData++
        // Load the chart data
        this.$fetch({
          method: "GET",
          url: uris[i],
          onResponse: function(response) {
            // Add the user return data to our model
            app.requestedData.push(response)
            app.loadingData--
            if(!app.loadingData) callback()
          },
        })
      }
    },
    loadQuarterCalories: function() {
      var app = this
      this.loadData(this.$fetchURI.dashboard.quarter_calories, function() {
        console.log("Oh my!")
        console.log(app)
        //app.chartObject = new Chart(app.$el)
      })
    },
  },
}