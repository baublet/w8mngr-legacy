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
    "newAmount",
  ],
  events: {
    'hook:ready': function() {
      // We initialize this as the number that users can play with, but it's not
      // really a prop, just part of the component's data
      this.newAmount = this.amount
    }
  },
  methods: {},
  computed: {
    selected: function() {
      return this.selectedMeasurement == this.index
    },
    cAmount: function() {
      var multiplier = parseFloat(this.newAmount / this.amount)
      if (multiplier !== NaN) return multiplier
      return this.amount
    },
    cCalories: function() {
      return Math.ceil(this.calories * this.cAmount)
    },
    cFat: function() {
      return Math.ceil(this.fat * this.cAmount)
    },
    cCarbs: function() {
      return Math.ceil(this.carbs * this.cAmount)
    },
    cProtein: function() {
      return Math.ceil(this.protein * this.cAmount)
    },
  },
})