// This is our food-entry item component, slim and easy to understand
w8mngr.foodEntries.components.foodEntry = Vue.extend({
  template: w8mngr.foodEntries.templates.foodEntry,
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
            self.$parent.entries.splice(index, 1)
            self.$parent.calculateTotals()
            w8mngr.loading.off()
          } else {
            alert("Unknown error...")
          }
        },
        onError: function(response) {
          alert("ERROR: " + response)
        }
      })
    },
  },
})