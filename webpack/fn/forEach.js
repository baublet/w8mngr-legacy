// Very simple looping class I like to use
module.exports = function(array, fn) {
  for (var i = 0; i < array.length; i++)
    fn(array[i], i);
}