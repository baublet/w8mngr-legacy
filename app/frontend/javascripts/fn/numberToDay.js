// Converts a number to a pretty date in the format passed

var numberToDate = require("./numberToDate.js")

module.exports = function(num, format) {
  format = format ? format : "%A, %B %e, %Y"
  if(num.length < 8) console.log("Number passed to numberToDay isn't valid: " . num)
  var date = numberToDate(num)
  return date.strftime(format)
}