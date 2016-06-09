var _do = require("../../fn/do.js")

// This is our measurement component coupled with AutocompleteItem
export default {
  props: [
    "index",
    "amount",
    "unit",
    "calories",
    "fat",
    "carbs",
    "protein",
    "id",
  ],
  data: function() {
    return {
      newAmount: 1,
      selected: false,
    }
  },
  events: {
    "hook:ready": function() {
      // Initialize the number that users can play with as the passed amount
      this.newAmount = this.amount
      // Watch the new amount form  for changes
      var self = this
      this.$watch('newAmount', function() {
        self.dispatchMeasurementInfo()
      })
    },
    "measurementSelected": function(id) {
      this.selected = false
      if(id == this.id) {
        this.selectMe()
      }
      return true
    },
  },
  methods: {
    selectMe: function() {
      this.selected = true
      // Focus on our measurements box and select the text
      var self = this
      _do(function() {
        self.$el.children[1].focus()
        self.$el.children[1].select()
      }, 100)
      this.dispatchMeasurementInfo()
    },
    // Our functions that we listen to for sending events up the chain
    nextMeasurement: function() {
      this.$dispatch("next-measurement")
    },

    previousMeasurement: function() {
      this.$dispatch("previous-measurement")
    },

    nextAutoCompleteItem: function() {
      this.$dispatch("next-autocomplete-item")
    },

    previousAutoCompleteItem: function() {
      this.$dispatch("previous-autocomplete-item")
    },

    // Pushes a notification up the chain to add the current entry
    addEntry: function() {
      this.$dispatch("add-entry")
      // Pings the server telling it to update this entry's popularity
      // Doesn't return anything because this is totally non-critical
      var self = this
      this.$fetch({
        method: "get",
        url: self.$fetchURI.measurements.increment_popularty(self.id),
      })
    },

    // This function sends the measurement info up the chain so that our main
    // app can fill it into the food log form
    dispatchMeasurementInfo: function() {
      var data = {
        description: this.newAmount + " " + this.unit + " " + this.$parent.name,
        calories: this.cCalories,
        fat: this.cFat,
        carbs: this.cCarbs,
        protein: this.cProtein,
      }
      this.$dispatch("fillin-form", data)
    }
  },
  computed: {
    cAmount: function() {
      if(this.amount == 0 || isNaN(this.newAmount)) return 1
      var multiplier = parseFloat(this.newAmount / this.amount)
      if (!isNaN(multiplier)) return multiplier
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
}