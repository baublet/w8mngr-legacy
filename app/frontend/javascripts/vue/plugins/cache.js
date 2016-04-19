// Cache so we don't have to load up certain things that don't really change
// often every single time we want it
var w8mngrCache = {}

// We store these in the following format:
/* {
      id: Number,
      name: String,
      description: String,
      measurements: [
        {
          id: Number,
          description: String,
          calories: Number,
          fat: Number,
          carbs: Number,
          protein: Number
        }
      ]
    }
*/
w8mngrCache.foods = {}

/* This function sets a cache type by the key. If the item is already in the
 * cache, it doesn't re-add it.
 *
 * The type needs to correspond to an object in the w8mngr.cache hash
 */
w8mngrCache.set = function(type, key, data) {
  var item = null
  if (type == "food") item = this.foods
  if (item == null) return false
  if (item[key] !== undefined) return false
  item[key] = data
  return true
}

w8mngrCache.get = function(type, key) {
  var item = null
  if (type == "food") item = this.foods
  if (item == null) return null
  if (item[key] == undefined) return null
  return item[key]
}

w8mngrCache.install = function(externalVue) {
  externalVue.cache = this
}

module.exports = w8mngrCache