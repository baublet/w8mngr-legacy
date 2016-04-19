// Converts the current day number to the previous day number
var numberToDate = require("./numberToDate.js")

module.export = function(num, format = "%Y%m%d") {
  var date = numberToDate(num)
  date.setDate(date.getDate() - 1)
  return date.strftime(format)
}
