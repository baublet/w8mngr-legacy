// A utility function for calculating our calories, fat, carbs, and proteins

module.exports = function(array, element) {
  var sum = 0
  array.forEach(function(entry) {
    sum = sum + parseInt(entry[element], 10)
  })
  return sum
}