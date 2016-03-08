// Day helper classes

// Converts a numeric string (e.g. 20160501) to a date object
w8mngr.fn.numberToDate = function(num) {
  if(num.length < 8) console.log("Number passed to numberToDay isn't valid: " . num)
  var year = num.substring(0, 4)
  var month = num.substring(4,6)
  var day = num.substring(6, 8)
  var date = new Date(parseInt(year), parseInt(month)-1, parseInt(day));
  console.log("Parsing date: " + year + month + day)
  console.log("Date object: " + date)
  return date
}

w8mngr.fn.numberToDay = function(num, format = "%A, %B %e, %Y") {
  if(num.length < 8) console.log("Number passed to numberToDay isn't valid: " . num)
  var date = w8mngr.fn.numberToDate(num)
  return date.strftime(format)
}
