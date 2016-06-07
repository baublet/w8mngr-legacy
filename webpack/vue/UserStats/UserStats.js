import DonutChart from "../DonutChart.vue"

export default {
  props: {
    macroPie: Array,
    macroPieLabels: Array,
    userStats: Object,
  },
  components: {
    DonutChart,
  },
  events: {
  }
}