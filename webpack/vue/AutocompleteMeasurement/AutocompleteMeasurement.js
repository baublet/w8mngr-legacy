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
    "measurement-selected": function(id) {
      if(id == this.id) {
        // Don't select this measurement if we're already selected
        console.log("Selecting measurement " + id + "...")
        if(this.selected == false) this.selectMe()
        else console.log("Nevermind! Already selected...")
      } else {
        this.selected = false
      }
    },
    // Our next/prev measurement and autocomplete listeners are
    // automatically passed up to the autocomplete item
    // Our add-entry and fill-in-form events are passed up
  },
  methods: {
    selectMe: function() {
      this.selected = true
      this.dispatchMeasurementInfo()
      // Focus on our measurements box and select the text
      this.selectBox()
    },

    // Selects the input box of this measumrent
    selectBox: function() {
      if (this.selected == false) return true
      this.$el.children[1].select()
    },

    // Pushes a notification up the chain to add the current entry
    addEntry: function() {
      this.$emit('add-entry')
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
      this.$emit('fill-in-form', data)
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