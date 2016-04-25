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
  ],
  methods: {
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