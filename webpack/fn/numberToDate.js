// Converts a numeric string (e.g. 20160501) to a date object
require("../utilities/strftime.js")

module.exports = function(num) {
  if(num.length < 8) console.log("Number passed to numberToDay isn't valid: " . num)
  var year = num.substring(0, 4)
  var month = num.substring(4,6)
  var day = num.substring(6, 8)
  var date = new Date(parseInt(year), parseInt(month)-1, parseInt(day));
  return date
}