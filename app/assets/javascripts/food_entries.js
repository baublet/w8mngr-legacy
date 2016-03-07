w8mngr.parseTotals = function(array, element) {
  var sum = 0
  w8mngr.forEach(array, function(entry) {
    sum = sum + parseInt(entry[element])
  })
  return sum
}

w8mngr.foodEntriesApp = new Vue({
  events: {
    'hook:created': function () {
      console.log('Loading food entries this...')
    },
    'hook:ready': function() {
      this.calculateTotals()
    }
  },
  el: '#food-entries-app',
  data: {
    newDescription: '',
    newCalories: '',
    newFat: '',
    newCarbs: '',
    newProtein: '',
    totalCalories: '',
    totalFat: '',
    totalCarbs: '',
    totalProtein: '',
    entries: [
      { id: 3, description:'This is an item', calories: 223, fat: 12, carbs: 30, protein: 10 },
      { id: 2, description:'This is also an item', calories: 50, fat: 1, carbs: 10, protein: 1 },
      { id: 1, description:'Hey, me, too!', calories: 175, fat: 3, carbs: 15, protein: 8 }
    ]
  },
  methods: {
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
      this.totalCalories = w8mngr.parseTotals(this.entries, 'calories')
      this.totalFat = w8mngr.parseTotals(this.entries, 'fat')
      this.totalCarbs = w8mngr.parseTotals(this.entries, 'carbs')
      this.totalProtein = w8mngr.parseTotals(this.entries, 'protein')
    }
  }
})
