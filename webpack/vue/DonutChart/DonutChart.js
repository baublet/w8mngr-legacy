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
      console.log("-------------------------Donut Chart Init")
      this.$log()
      console.log("-------------------------Donut Chart Init\n\n")
      this.chartObject = new Chart(this.$el, {
        type: 'doughnut',
        options: {
          tooltips: {
            callbacks: {
              label: function(a, b) {
                // This function turns the regular label into a more descriptive
                // percentage and grams
                var total, dset, i, data, num, label, percent
                dset = a.datasetIndex
                i = a.index
                data = b.datasets[dset].data
                num  = data[i]
                total = data.reduce(function(a, b) {return a + b})
                label = b.labels[i]
                percent = ((num / total) * 100).toFixed(1)
                return label + ": " +  percent + "%" +
                        " (" + num.toLocaleString() + "g)"
              }
            }
          }
        },
        data: {
          labels: this.labels,
          datasets: [
              {
                  data: this.values,
                  backgroundColor: [
                      "#FFAA00",
                      "#F63700",
                      "#007E80"
                  ],
                  hoverBackgroundColor: [
                      "#FFBF40",
                      "#FF6727",
                      "#00B9BD"
                  ]
              }
          ]
        }
      })
    }
  },
  events:{
    'dataLoaded': function() {
      console.log("-------------------------DataLoaded Donut Chart")
      this.$log()
      console.log("-------------------------\n\n")
      if(this.values && this.labels)
        if(this.values.length && this.labels.length)
          this.init()
      return true
    }
  }
}