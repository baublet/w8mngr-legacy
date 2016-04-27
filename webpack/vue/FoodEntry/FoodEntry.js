// This is our food-entry item component, slim and easy to understand
export default {
  props: [
    "loading",
    "id",
    "index",
    "description",
    "calories",
    "fat",
    "carbs",
    "protein",
    // An array of calories, fats, carbs, and protein per single unit of these
    "perOne",
  ],
  events: {
    "hook:ready": function() {
      // Calculate our "perOne" array so that the user can later change this
      this.perOne = {}
      // First, find the number at the beginning (if there is one)
      var re = /^([\d\.]+)/
      var findNumber = re.exec(this.description)
      var number = 1
      if (findNumber !== null) number = parseFloat(findNumber[0])
      // Make sure it's not 0
      if (number == 0) number = 1
      // Now divide our macros by this number
      this.perOne.calories = this.calories / number
      this.perOne.fat = this.fat / number
      this.perOne.carbs = this.carbs / number
      this.perOne.protein = this.protein / number
      console.log(this.perOne)

      var self = this
      // Attach an event listener to our focus so that we can select just the
      // beginning number when the user selects the field (for easy editing)
      this.$el.children[0].children[0].addEventListener("focus", function() {
        self.focusEvent(this)
      })
      // Attach a listener to the description so that users can change the amount
      // and it updates the values automatically
      this.$watch("description", function(newValue) {
        self.calculateNewTotals(newValue)
      })
    },
  },
  methods: {
    calculateNewTotals: function(newValue) {
      console.log("Calculating new totals based on change spotted in entry description...")
      var re = /^([\d\.]+)/

      // Find the new amount
      var newamount = re.exec(newValue)
      // No new amount found? Let's just ignore it
      if (newamount == null) return false
      // Otherwise, let's make it a float!
      else newamount = parseFloat(newamount[0])

      console.log("New amount: " + newamount)

      this.calories = Math.ceil(this.perOne.calories * newamount)
      this.fat = Math.ceil(this.perOne.fat * newamount)
      this.carbs = Math.ceil(this.perOne.carbs * newamount)
      this.protein = Math.ceil(this.perOne.protein * newamount)
    },
    // For focusing the description. When a user clicks a description, this event
    // fires, selecting only the number at the beginning
    focusEvent: function(el) {
      var amount = /^([\d\.]+)/
      var match = amount.exec(el.value)
      if (match == null) return false
      el.setSelectionRange(0, match[0].length)
    },
    // Sends an entry to be removed from the database
    removeEntry: function(index) {
      this.loading = 1
      var self = this
      this.$fetch({
        method: "DELETE",
        url: self.$fetchURI.food_entries.delete(self.id),
        onSuccess: function(response) {
          if (response.success === true) {
            self.$parent.entries.splice(self.index, 1)
            self.$parent.calculateTotals()
            self.loading = 0
          } else {
            alert("Unknown error...")
          }
        },
        onError: function(response) {
          alert("ERROR: " + response)
        },
      })
    },
    // Sends an entry to be saved to the database
    saveEntry: function(index) {
      this.loading = 1
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
          if (response.success == true) {
            self.loading = 0
          } else {
            alert("Unknown error...")
          }
        },
        onError: function(response) {
          alert("ERROR:" + response)
        },
      })
    },
  },
}