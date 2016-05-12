var addEvent = require("../../fn/addEvent.js")

// This is our food-entry item component, slim and easy to understand
export default {
  props: [
    "id",
    "index",
    "description",
    "calories",
    "fat",
    "carbs",
    "protein",
    // For calculating changes in our amounts on the fly
    "perOne",
  ],
  events: {
    'hook:ready': function() {
      // First, find the number at the beginning
      var chunks = this.description.split(" ")
      var currentAmount = parseFloat(chunks[0])
      if (isNaN(currentAmount) || currentAmount == 0) currentAmount = 1

      // Calculate the new perOne values
      var multiplier = 1 / currentAmount
      this.perOne = {}
      this.perOne.calories = this.calories * multiplier
      this.perOne.fat = this.fat * multiplier
      this.perOne.carbs = this.carbs * multiplier
      this.perOne.protein = this.protein * multiplier

      // Watch for our amount to change
      // Watch for autocomplete results
      this.$watch("description", function() {
        this.$emit("amountAltered")
      })

      // Listen for events on all of our macros
      var selectFunction = function() {
        var el = this
        setTimeout(function() {
          el.selectionStart = 0
          el.selectionEnd = 9
        }, 100)
      }
      addEvent(this.$el.children[1].children[0], ["focus", "click"], selectFunction)
      addEvent(this.$el.children[2].children[0], ["focus", "click"], selectFunction)
      addEvent(this.$el.children[3].children[0], ["focus", "click"], selectFunction)
      addEvent(this.$el.children[4].children[0], ["focus", "click"], selectFunction)
    },
    // This function watches for our description to change. When it does, we
    // call this function to see if the amount was altered, and if it was, update
    // the item's macros according to the new amount
    'amountAltered': function() {
      var chunks = this.description.split(" ")
      var newAmount = parseFloat(chunks[0])
      if(isNaN(newAmount) || newAmount == 0) return null

      // So we have a valid new amount, let's update it!
      this.calories = Math.ceil(this.perOne.calories * newAmount)
      this.fat = Math.ceil(this.perOne.fat * newAmount)
      this.carbs = Math.ceil(this.perOne.carbs * newAmount)
      this.protein = Math.ceil(this.perOne.protein * newAmount)
    },
  },
  methods: {
    // Selects the first part of a food if that first part is a number
    selectDescription: function() {
      var app = this
      setTimeout(function() {
        var el = app.$el.children[0].children[0]
        var chunks = app.description.split(" ")
        var currentAmount = parseFloat(chunks[0])
        if (!isNaN(currentAmount)) {
          el.selectionStart = 0
          el.selectionEnd = chunks[0].length
        } else {
          el.selectionStart = 0
          el.selectionEnd = 999
        }
      }, 100)
    },
    // Sends an entry to be removed from the database
    removeEntry: function(index) {
      this.$dispatch("loading")
      var self = this
      this.$fetch({
        method: "DELETE",
        url: self.$fetchURI.food_entries.delete(self.id),
        onSuccess: function(response) {
          self.$parent.entries.splice(self.index, 1)
          self.$parent.calculateTotals()
          self.$dispatch("notLoading")
        },
      })
    },
    // Sends an entry to be saved to the database
    saveEntry: function(index) {
      this.$dispatch("loading")
      this.$parent.calculateTotals()

      // Prepare our data to be sent
      var data = {
        food_entry: {
          description: this.description,
          calories: this.calories,
          fat: this.fat,
          carbs: this.carbs,
          protein: this.protein,
        }
      }

      // Make our request
      var self = this
      this.$fetch({
        method: "PATCH",
        url: this.$fetchURI.food_entries.update(self.id),
        data: data,
        onSuccess: function(response) {
          self.$dispatch("notLoading")
        },
      })
    },
  },
}