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
          this.LoadQuarterCalories()
          break
      }
    },
  },
  methods: {
    // Transforms our data from [[Date, Value], ...] to [{x: Date, y: Value}, ...]
    MassageData: function(data) {
      return data.map(function(a){
        let y = !a[1] ? null : parseInt(a[1], 10)
        return {x: a[0], y: y}
      })
    },
    // Finds the min and max of the called functions (to be used AFTER data has
    // been massaged)
    FindMax: function(data) {
      var max = 0
      data.forEach(function(a){
        if (a.y > max) max = a.y
      })
      return max
    },
    FindMin: function(data) {
      var min = null
      data.forEach(function(a){
        if(a.y == null) return
        if (min == null) min = a.y
        else if (a.y < min) min = a.y
      })
      return min
    },
    LoadData: function(uris, callback) {
      this.data = {}
      if (typeof uris !== "object") uris = [uris]
      this.loadingData = uris.length
      console.log("Loading line chart data from " + uris.length + " URIs:")
      console.log(uris)
      var app = this
      for(let i = 0; i < uris.length; i++) {
        let name = uris[i][0],
            val  = uris[i][1]
        console.log("Loading line chart data from " + uris[i][1] + " (" + i + ")")
        // Load the chart data
        this.$fetch({
          method: "GET",
          url: val,
          onSuccess: function(response) {
            // Massage the data so it fits with our scatter chart & add it to our model
            app.data[name] = app.MassageData(response)
            app.loadingData--
            if(app.loadingData == 0) callback()
          },
        })
      }
    },
    LoadQuarterCalories: function() {
      var app = this
      var uris = [
                  ['calories', this.$fetchURI.dashboard.quarter_calories ],
                  ['weights',  this.$fetchURI.dashboard.quarter_weights  ],
                 ]
      this.LoadData(uris, function() {
        console.log("MAKING CHART")
        console.log("Weights:")
        console.log(app.data.calories)
        let max_calories_y = parseInt(app.FindMax(app.data.calories) * 1.5, 10),
            min_weights_y  = parseInt(app.FindMin(app.data.weights) * 0.7, 10),
            max_weights_y =  parseInt(app.FindMax(app.data.weights) * 1.2, 10)
        app.chartObject = new Chart(app.$el, {
          type: 'bar',
          options: {
            scales: {
              xAxes: [
                {
                  ticks: {
                    maxTicksLimit: 5,
                    max: max_calories_y,
                  },
                  gridLines: {
                    display: false,
                  },
                }
              ],
              yAxes: [
                {
                  scaleType: 'linear',
                  id: 'calories',
                  position: 'right',
                  gridLines: {
                    display: false,
                  },
                  ticks: {
                    maxTicksLimit: 5,
                    max: max_calories_y,
                  }
                },
                {
                  scaleType: 'linear',
                  id: 'weights',
                  position: 'left',
                  gridLines: {
                    display: false,
                  },
                  ticks: {
                    maxTicksLimit: 5,
                    min: min_weights_y,
                    max: max_weights_y,
                  },
                },
              ],
            },
            legend: {
              display: true,
              position: "bottom",
            },
          },
          data: {
            labels: app.data.calories.map(function(a){
              return new Date(a.x).strftime("%B")
            }),
            datasets: [
              {
                label: "Calories",
                type: 'bar',
                data: app.data.calories.map(function(a){return a.y}),
                yAxisID: 'calories',
              },
              {
                label: "Weights",
                borderColor: "rgba(0,0,0,1)",
                data: app.data.weights.map(function(a){return a.y}),
                fill: false,
                yAxisID: 'weights',
                type: 'line',
                lineTension: 0.4,
                spanGaps: true,
              },
            ],
          },
        })
      })
    },
  },
}