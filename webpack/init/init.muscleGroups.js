var w8mngr = require("w8mngr")
var addEvent = require("../fn/addEvent.js")

w8mngr.init.addIf("muscle-groups-form", function() {
  function findElementParentID(el, max) {
    max = max ? max : 5
    let id = null
    for(let i = 0; i < max; i++) {
      id = el.path[i].id.toLowerCase()
      if(id) return id
    }
    return null
  }
  document.querySelectorAll(".muscle-groups svg g g[id]").forEach(function(group) {
    // For the hover
    addEvent(group, 'mouseover', function(el) {
      let id = findElementParentID(el)
      let label = document.querySelectorAll("label[for=activity_muscle_groups_" + id + "]")[0]
      let clss = 'hover'

      if (label.classList) label.classList.add(clss)
      else label.className += ' ' + clss
    })
    addEvent(group, 'mouseout', function(el) {
      let id = findElementParentID(el)
      let label = document.querySelectorAll("label[for=activity_muscle_groups_" + id + "]")[0]
      let clss = "hover"

      if (label.classList) label.classList.remove(clss)
      else label.className = label.className.replace(new RegExp('(^|\\b)' + clss.split(' ').join('|') + '(\\b|$)', 'gi'), ' ')
    })
    // For the click
    addEvent(group, ['click', 'touchstart'], function(el) {
      el.stopPropagation()
      el.preventDefault()
      let id = findElementParentID(el)
      let input = document.getElementById('activity_muscle_groups_' + id)

      if(input.checked) input.checked = false
      else input.checked = true
      return false
    })
  })
})