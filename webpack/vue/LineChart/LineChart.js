var Chart = require("chart.js")
require("../../utilities/strftime.js")

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
            response = JSON.parse(response)
            var cleaned = Object.keys(response).map(function (key) {return [key, response[key]]})
            app.data.push(cleaned)
            app.loadingData--
            if(!app.loadingData) callback()
          },
        })
      }
    },
    loadQuarterCalories: function() {
      var app = this
      uris = [
        this.$fetchURI.dashboard.quarter_calories,
        this.$fetchURI.dashboard.quarter_weights
        ]
      this.loadData(uris, function() {
        console.log("MAKING CHART")
        // Make our labels from the first data set (they will be matched on the
        // backend by Postgres automatically)
        var labels = app.data[0].map(function(a){return new Date(a[0]).strftime("%B %e")})
        app.chartObject = new Chart(app.$el, {
          type: 'bar',
          options: {
            legend: {
              display: true,
              position: "bottom",
            },
          },
          data: {
            labels: labels,
            datasets: [
              {
                label: "Calories",
                borderColor: "rgba(0,0,0,1)",
                data: app.data[0].map(function(a){
                  if(!a[1]) return null
                  return a[1]
                }),
                lineTension: .7,
                pointRadius: 0,
                fill: false,
              }
            ],
          },
        })
      })
    },
  },
}