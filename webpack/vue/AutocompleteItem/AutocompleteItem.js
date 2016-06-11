var smoothScroll  = require("../../fn/smoothScroll.js")
var _do = require("../../fn/do.js")

import AutocompleteMeasurement from '../AutocompleteMeasurement.vue'

// This is our overarching food entries instance
// This is our autocomplete item component, slim and easy to understand
export default {
  components: {
   AutocompleteMeasurement,
  },
  props: [
    "index",
    "name",
    "resource",
  ],
  data: function() {
    return {
      selectedMeasurement: 0,
      measurementsLoaded: 0,
      selected: false,
      loading: 1,
      measurements: [],
    }
  },
  events: {
    'hook:attached': function() {
      this.initializeComponent()
    },
    'autocomplete-item-selected': function(index) {
      index = index > 0 ? index : 0
      this.selected = false
      if (index == this.index) {
        this.selectItem()
      }
    },
    'next-measurement': function() {
      if(!this.selected) return true
      this.nextMeasurement()
    },
    'prev-measurement': function() {
      if(!this.selected) return true
      this.prevMeasurement()
    },
    // Our next/prev autocomplete events are passed up
    // Our add-entry and fill-in-form events are passed up
  },
  methods: {
    selectItem: function() {
      // We send this up, which then sends it back down to the children
      // This is for clicking on items, rather than using keyboard navigation
      console.log("Selecting item " + this.index)
      this.selected = true
      // Load measurements
      this.loadItemData()
      // Scroll to this item if we're on small screens
      if (window.innerWidth < 640)
        smoothScroll.scrollVerticalToElementById(this.$el.id, 150)
    },
    selectMeasurement: function() {
      console.log("Selecting measurement...")
      // If we don't do this asyncronously, Vue won't have time to update the
      // the DOM. This will defer the ping until Vue has time to update
      var self = this
      _do(function() {
        // But we only want to do it a certain number of times to not fully stuff
        // up the app if something goes wrong
        let i = 0
        while(!self.measurements[self.selectedMeasurement] && i < 1000) {i++}
        // Emit the event to our children
        self.$children.forEach(function(m) {
          m.$emit("measurement-selected", self.measurements[self.selectedMeasurement].id)
        })
      }, 50)
    },
    firstMeasurement: function() {
      this.selectedMeasurement =  0
      this.selectMeasurement()
    },
    nextMeasurement: function() {
      if(this.selectedMeasurement + 1 > this.measurements.length - 1) return false
      this.selectedMeasurement++
      this.selectMeasurement()
    },
    prevMeasurement: function() {
      if(this.selectedMeasurement) this.selectedMeasurement--
      this.selectMeasurement()
    },
    initializeComponent: function() {
      // Set a random ID on this measurement (because we never use these IDs in the CSS,
      // or anywhere else in the JS but here)
      this.$el.id = "ac-item-" + Math.random().toString(36).substring(7)
      this.loading = 0
    },
    // This loads an autocomplete item's data and attaches it to the parent component
    loadItemData: function() {

      // Only continue if we haven't already loaded these measurements
      if (this.measurementsLoaded || this.loading) {
        this.firstMeasurement()
        return 1
      }

      this.loading = 1

      var in_cache = this.$cache.get("food", this.resource)
      if (in_cache !== null) {
        console.log("Item found in the cache for " + this.name + ". Loading it into Vue.")
        this.$set('measurements', in_cache.measurements)
        //this.measurements = in_cache.measurements
        this.measurementsLoaded = 1
        this.loading = 0
        // Make sure we select our first measurement
        this.firstMeasurement()
        return null
      }
      console.log("Loading item data for: " + this.index)

      var self = this

      this.$fetch({
        method: "get",
        url: self.resource,
        onSuccess: function(response) {
          self.loading = 0
          if (response.success === false) {
            alert("Unknown error...")
          } else {
            self.$set('measurements', response.measurements)
            self.measurementsLoaded = 1

            self.$cache.set("food", self.resource, {
              id: self.id,
              name: self.name,
              measurements: response.measurements,
            })

            // Make sure we select our first measurement
            self.firstMeasurement()
          }
        },
        onError: function(response) {
          alert("ERROR: " + response)
        }
      })

    },
  },
}