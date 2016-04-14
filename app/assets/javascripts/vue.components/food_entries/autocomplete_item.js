// This is our autocomplete item component, slim and easy to understand
w8mngr.foodEntries.components.autoCompleteItem = Vue.extend({
  template: w8mngr.foodEntries.templates.autoCompleteItem,
  components: {
    "measurement-item": w8mngr.foodEntries.components.measurementItem,
  },
  props: [
    "index",
    "name",
    "resource",
    "description",
    "measurementsLoaded",
    "measurements",
    "selectedMeasurement",
  ],
  events: {
    'hook:ready': function() {
      this.initializeComponent()
    },
  },
  methods: {
    addEntry() {
      this.$dispatch('add-entry')
    },
    initializeComponent() {
      // Watch for this item to be selected
      this.$watch("$parent.autoCompleteSelected", function(index) {
        if (index == this.index) this.loadItemData()
      })
    },
    // This loads an autocomplete item's data and attaches it to the parent component
    loadItemData() {

      // Only continue if we haven't already loaded these measurements
      if (this.measurementsLoaded) return false

      var in_cache = w8mngr.cache.get("food", this.resource)
      console.log(in_cache)
      if (in_cache !== null) {
        console.log("Item found in the cache for " + this.name + ". Loading it into Vue.")
        this.measurements = in_cache.measurements
        this.measurementsLoaded = 1
        return true
      }

      console.log("Loading item data for: " + this.index)

      var self = this

      w8mngr.fetch({
        method: "get",
        url: self.resource,
        onSuccess: function(response) {
          if (response.success === false) {
            alert("Unknown error...")
          } else {
            self.measurements = response.measurements
            self.description = response.description
            self.measurementsLoaded = 1
            w8mngr.cache.set("food", self.resource, {
              id: self.id,
              name: self.name,
              description: self.description,
              measurements: self.measurements,
            })

            // Make sure we add a selected class to our measurement
            self.selectedMeasurement = 0
          }
        },
        onError: function(response) {
          alert("ERROR: " + response)
        }
      })

    },
  },
  computed: {
    selected: function() {
      if (this.$parent.autoCompleteSelected == this.index) return true
      return false
    }
  },
})