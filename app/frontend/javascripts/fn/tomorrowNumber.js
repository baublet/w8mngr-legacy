// Converts the current day number to the next day number

var numberToDate = require("./numberToDate.js")

module.exports = function(num, format = "%Y%m%d") {
  var date = w8mngr.fn.numberToDate(num)
  date.setDate(date.getDate() + 1)
  return date.strftime(format)
}
