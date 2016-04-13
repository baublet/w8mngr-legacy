// This is our measurement component coupled with autocomplete_item
w8mngr.foodEntries.components.measurementItem = Vue.extend({
  template: w8mngr.foodEntries.templates.measurementItem,
  props: [
    "index",
    "amount",
    "unit",
    "calories",
    "fat",
    "carbs",
    "protein",
    // We have to pass this down we know when we should select ourselves
    "selectedMeasurement",
  ],
  methods: {},
  computed: {
    selected: function() {
      return this.selectedMeasurement == this.index
    }
  },
})