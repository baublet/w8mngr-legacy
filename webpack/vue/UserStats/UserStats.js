import DonutChart from "../DonutChart.vue"

export default {
  props: {
    macroPie: Array,
    macroPieLabels: Array,
  },
  components: {
    DonutChart,
  },
  events: {
    'dataLoaded': function() {
      console.log("-----------DataLoaded on UserStats")
      this.$log()
      console.log("-----------\n\n")
      var mp, mpl
      mp = this.macroPie
      mpl = this.macroPieLabels
      this.$set('macroPie', mp)
      this.$set('macroPieLabels', mpl)
      return true
    }
  }
}