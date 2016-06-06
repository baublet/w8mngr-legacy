import LineChart from "../LineChart.vue"
import WeekInReview from "../WeekInReview.vue"

export default {
  el: "#dashboard-app",
  events: {
    "hook:ready": function() {
      console.log("Loaded dashboard...")
    },
  },
  computed: {
  },
  data: {
  },
  components: {
    LineChart,
    WeekInReview,
  },
  methods: {
  },
}