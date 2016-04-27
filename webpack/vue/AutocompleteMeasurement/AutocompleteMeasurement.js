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
    // We have to pass this down so we know when we should select ourselves
    "selectedMeasurement",
  ],
  data: function() {
    return {
      newAmount: 1,
    }
  },
  events: {
    "hook:ready": function() {
      // Initialize the number that users can play with as the passed amount
      this.newAmount = this.amount
    },
    "selected": function() {
      if(this.selectedMeasurement !== this.index) return false

      // Focus on our measurements box and select the text
      var self = this
      _do(function() {
        self.$el.children[1].focus()
        self.$el.children[1].select()
      }, 100)
    },
  },
  methods: {
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
    },

    // This function sends the measurement info up the chain so that our main
    // app can fill it into the food log form
    dispatchMeasurementInfo: function() {
      var data = {
        description: this.cAmount + " " + this.unit + " " + this.$parent.name,
        calories: this.cCalories,
        fat: this.cFat,
        carbs: this.cCarbs,
        protein: this.cProtein,
      }
      this.$dispatch("fillin-form", data)
    }
  },
  computed: {
    selected: function() {
      if (this.selectedMeasurement == this.index) {
        // Send an event up the chain telling it to update the field
        this.dispatchMeasurementInfo()
        // Focus on our measurements box and select the text
        this.$emit("selected")
        return true
      }
      return false
    },
    cAmount: function() {
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