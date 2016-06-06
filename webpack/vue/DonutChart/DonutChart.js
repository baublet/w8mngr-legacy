var Chart = require("chart.js")

export default {
  props: {
    values: Array,
    labels: Array,
  },
  data: function() {
    return {
      chartObject: {},
    }
  },
  methods: {
    init: function() {
      console.log(this)
      console.log(this.values)
      console.log(this.labels)
      var app = this
      this.chartObject = new Chart(this.$el, {
        type: 'doughnut',
        data: {
          labels: app.labels,
          datasets: [
              {
                  data: app.values,
                  backgroundColor: [
                      "yellow",
                      "red",
                      "black"
                  ],
                  hoverBackgroundColor: [
                      "#FF6384",
                      "#36A2EB",
                      "#FFCE56"
                  ]
              }
          ],
        }
      })
    }
  },
  ready: function() {
      console.log("dataLoaded called in donut")
      console.log(this.values)
      console.log(this.labels)
      if(!this.values || !this.labels) return null
      this.init()
  }
}