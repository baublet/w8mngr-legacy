// Converts the current day number to the previous day number
var numberToDate = require("./numberToDate.js")

module.exports = function(num, format) {
  format = format ? format : "%Y%m%d"
  var date = numberToDate(num)
  date.setDate(date.getDate() - 1)
  return date.strftime(format)
}
