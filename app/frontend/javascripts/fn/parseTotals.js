var forEach  = require("forEach.js")

// A utility function for calculating our calories, fat, carbs, and proteins

module.exports = function(array, element) {
    var sum = 0
    forEach(array, function(entry) {
      sum = sum + parseInt(entry[element], 10)
    })
    return sum
  }