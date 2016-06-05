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
      data: {},
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
      this.data = {}
      if (typeof uris !== "object") uris = [uris]
      console.log("Loading line chart data from URIs:")
      console.log(uris)
      var app = this
      for(var i = 0; i < uris.length; i++) {
        let name = uris[i][0],
            val  = uris[i][1]
        this.loadingData++
        // Load the chart data
        this.$fetch({
          method: "GET",
          url: val,
          onSuccess: function(response) {
            // Add the user return data to our model
            console.log(response)
            app.data[name] = response
            app.loadingData--
            if(!app.loadingData) callback()
          },
        })
      }
    },
    loadQuarterCalories: function() {
      var app = this
      var uris = [
                  ['calories', this.$fetchURI.dashboard.quarter_calories ],
                  ['weights',  this.$fetchURI.dashboard.quarter_weights  ],
                 ]
      this.loadData(uris, function() {
        console.log("MAKING CHART")
        // Make our labels from our calories
        var labels = app.data.calories.map(function(a){return new Date(a[0]).strftime("%B %e")})
        app.chartObject = new Chart(app.$el, {
          type: 'bar',
          options: {
            scales: {
              yAxes: [
                {
                  scaleType: 'linear',
                  id: 'calories',
                  position: 'right',
                },
                {
                  scaleType: 'linear',
                  id: 'weights',
                  position: 'left',
                },
              ],
            },
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
                data: app.data.calories.map(function(a){
                  if(!a[1]) return null
                  return a[1]
                }),
                yAxisID: 'calories',
              },
              {
                label: "Weights",
                borderColor: "rgba(0,0,0,1)",
                data: app.data.weights.map(function(a){
                  if(!a[1]) return null
                  return a[1]
                }),
                lineTension: .7,
                pointRadius: 0,
                fill: false,
                type: 'line',
                yAxisID: 'weights',
              }
            ],
          },
        })
      })
    },
  },
}