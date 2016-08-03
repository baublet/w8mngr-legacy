// Selects the text in the passed form field based on what they want to select

module.exports = function(el, context) {
  if (context === 'amount') {
    // Get all of the chunks of this string, so we can just analyze the first
    let chunks = el.value.split(" ")
    let currentAmount = parseFloat(chunks[0])
    // Is the first chunk a number of any sort? If so,  just select that
    if (!isNaN(currentAmount)) {
      el.selectionStart = 0
      el.selectionEnd = chunks[0].length
    } else {
      // Otherwise, select the whole thing
      el.selectionStart = 0
      el.selectionEnd = 999
    }
  } else {
    el.selectionStart = 0
    el.selectionEnd = 999
  }
}