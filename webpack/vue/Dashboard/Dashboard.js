// This is our Vue instance for any Dashboard or Dashboard-related charts, info,
// graphs, and stat tables

export default {
  el: "#dashboard-app",
  data: {
    loading: 1,
    lineCharts: [],
    pieCharts: [],
    barCharts: [],
    statTables: [],
  },
  events: {
    "hook:ready": function() {
      this.initializeApp()
    },
  },
  methods: {

  },
}