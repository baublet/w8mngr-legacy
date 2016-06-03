import LineChart from "../LineChart.vue"

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
  },
  methods: {
  },
}