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
  methods: {
    // Our functions that we listen to for sending events up the chain
    nextMeasurement: function() {
      this.$dispatch('next-measurement')
    },

    previousMeasurement: function() {
      this.$dispatch('previous-measurement')
    },

    // Pushes a notification up the chain to add the current entry
    addEntry: function() {
      this.$dispatch('add-entry')
    },

    // This function sends the measurement info up the chain so that our main
    // app can fill it into the food log form
    dispatchMeasurementInfo: function() {
      var data = {
        description: this.amount + " " + this.unit + " " + this.$parent.name,
        calories: this.cCalories,
        fat: this.cFat,
        carbs: this.cCarbs,
        protein: this.cProtein,
      }
      this.$dispatch('fillin-form', data)
    }
  },
  computed: {
    selected: function() {
      if (this.selectedMeasurement == this.index) {
        // Send an event up the chain telling it to update the field
        this.dispatchMeasurementInfo()
        return true
      }
      return false
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