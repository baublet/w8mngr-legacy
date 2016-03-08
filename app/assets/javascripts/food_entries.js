w8mngr.fn.parseTotals = function(array, element) {
  var sum = 0
  w8mngr.fn.forEach(array, function(entry) {
    sum = sum + parseInt(entry[element])
  })
  return sum
}

w8mngr.foodEntriesApp = new Vue({
  events: {
    'hook:ready': function() {
      this.initializeData()
    }
  },
  el: '#food-entries-app',
  data: {
    currentDayNumber: '',
    currentDay: '',
    newDescription: '',
    newCalories: '',
    newFat: '',
    newCarbs: '',
    newProtein: '',
    totalCalories: '',
    totalFat: '',
    totalCarbs: '',
    totalProtein: '',
    entries: []
  },
  methods: {
    initializeData: function() {
      w8mngr.loading.on()
      console.log("Fetching data from the API...")
      var app = this
      w8mngr.fetch({
        method: "GET",
        url: w8mngr.config.resources.food_entries.index,
        onSuccess: function(response) {
          app.entries = response.entries
          app.currentDayNumber = response.current_day
          app.calculateTotals()
          w8mngr.loading.off()
        },
        onError: function() {
          alert("ERROR:" + response)
        }
      })
    },
    addEntry: function () {
      var description = this.newDescription.trim()
      var calories = parseInt(this.newCalories.trim()) || 0
      var fat = parseInt(this.newFat.trim()) || 0
      var carbs = parseInt(this.newCarbs.trim()) || 0
      var protein = parseInt(this.newProtein.trim()) || 0
      if (description && calories) {
        this.entries.push({ description: description, calories: calories, fat: fat, carbs: carbs, protein: protein })
        this.newDescription = ''
        this.newCalories = ''
        this.newFat = ''
        this.newCarbs = ''
        this.newProtein = ''
        console.log(this)
        this.calculateTotals(this)
      } else {
        alert("You need at least a description and calories!")
      }
    },
    removeEntry: function (index) {
      this.entries.splice(index, 1)
      this.calculateTotals()
    },
    saveEntry: function() {
      this.calculateTotals()
    },
    calculateTotals: function() {
      console.log('Calculating totals...')
      this.totalCalories = w8mngr.fn.parseTotals(this.entries, 'calories')
      this.totalFat = w8mngr.fn.parseTotals(this.entries, 'fat')
      this.totalCarbs = w8mngr.fn.parseTotals(this.entries, 'carbs')
      this.totalProtein = w8mngr.fn.parseTotals(this.entries, 'protein')
    }
  }
})
