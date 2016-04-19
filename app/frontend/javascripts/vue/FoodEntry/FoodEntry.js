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
  ],
  methods: {
    // Sends an entry to be removed from the database
    removeEntry: function(index) {
      w8mngr.loading.on()
      var self = this
      w8mngr.fetch({
        method: "DELETE",
        url: w8mngr.config.resources.food_entries.delete(self.id),
        onSuccess: function(response) {
          if (response.success === true) {
            self.$parent.entries.splice(self.index, 1)
            self.$parent.calculateTotals()
            w8mngr.loading.off()
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
      w8mngr.loading.on()
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
      w8mngr.fetch({
        method: "PATCH",
        url: w8mngr.config.resources.food_entries.update(self.id),
        data: data,
        onSuccess: function(response) {
          if (response.success == true) {
            w8mngr.loading.off()
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