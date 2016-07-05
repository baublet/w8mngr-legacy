var w8mngr = require("w8mngr")
var addEvent = require("../fn/addEvent.js")

w8mngr.init.addIf("muscle-groups-form", function() {
  document.querySelectorAll(".muscle-groups svg g g[id]").forEach(function(group) {
    function findElementParentID(el, max) {
      max = max ? max : 5
      let id = null
      for(let i = 0; i < max; i++) {
        id = el.path[i].id.toLowerCase()
        if(id) return id
      }
      return null
    }
    // For the hover
    group.addEventListener('mouseover', function(el) {
      // Try the first five elements in the event tree
      let id = findElementParentID(el)

      let label = document.querySelectorAll("label[for=activity_muscle_groups_" + id + "]")[0]
      if(!label) {
        console.log("Couldn't find element label[for=activity_muscle_groups_" + id + "]...")
        console.log(el)
        return false
      }
      let clss = 'hover'

      if (label.classList) label.classList.add(clss)
      else label.className += ' ' + clss
    })
    group.addEventListener('mouseout', function(el) {
      let id = findElementParentID(el)

      let label = document.querySelectorAll("label[for=activity_muscle_groups_" + id + "]")[0]
      if(!label) {
        console.log("Couldn't find element label[for=activity_muscle_groups_" + id + "]...")
        console.log(el)
        return false
      }
      let clss = "hover"

      if (label.classList) label.classList.remove(clss)
      else label.className = label.className.replace(new RegExp('(^|\\b)' + clss.split(' ').join('|') + '(\\b|$)', 'gi'), ' ')
    })
    // For the click
    group.addEventListener('click', function(el) {
      let id = findElementParentID(el)

      let input = document.getElementById('activity_muscle_groups_' + id)
      if(!input) {
        console.log("Couldn't find element activity_muscle_groups_" + id + "...")
        console.log(el)
        return false
      }

      if(input.checked) input.checked = false
      else input.checked = true
    });
  })
})