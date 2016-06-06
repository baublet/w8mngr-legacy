import LineChart from "../LineChart.vue"
import WeekInReview from "../WeekInReview.vue"
import UserStats from "../UserStats.vue"

export default {
  el: "#dashboard-app",
  events: {
    "hook:ready": function() {
      console.log("Loaded dashboard...")
    },
    "loading": function() {
      this.loading = 1
    },
    "notLoading": function() {
      this.loading = 0
    },
  },
  computed: {
  },
  data: {
    loading: 1,
  },
  components: {
    LineChart,
    WeekInReview,
    UserStats,
  },
  methods: {
  },
}