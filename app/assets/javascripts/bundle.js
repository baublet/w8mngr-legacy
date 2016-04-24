/******/ (function(modules) { // webpackBootstrap
/******/ 	// install a JSONP callback for chunk loading
/******/ 	var parentJsonpFunction = window["webpackJsonp"];
/******/ 	window["webpackJsonp"] = function webpackJsonpCallback(chunkIds, moreModules) {
/******/ 		// add "moreModules" to the modules object,
/******/ 		// then flag all "chunkIds" as loaded and fire callback
/******/ 		var moduleId, chunkId, i = 0, callbacks = [];
/******/ 		for(;i < chunkIds.length; i++) {
/******/ 			chunkId = chunkIds[i];
/******/ 			if(installedChunks[chunkId])
/******/ 				callbacks.push.apply(callbacks, installedChunks[chunkId]);
/******/ 			installedChunks[chunkId] = 0;
/******/ 		}
/******/ 		for(moduleId in moreModules) {
/******/ 			modules[moduleId] = moreModules[moduleId];
/******/ 		}
/******/ 		if(parentJsonpFunction) parentJsonpFunction(chunkIds, moreModules);
/******/ 		while(callbacks.length)
/******/ 			callbacks.shift().call(null, __webpack_require__);

/******/ 	};

/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// object to store loaded and loading chunks
/******/ 	// "0" means "already loaded"
/******/ 	// Array means "loading", array contains callbacks
/******/ 	var installedChunks = {
/******/ 		0:0
/******/ 	};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}

/******/ 	// This file contains only the entry chunk.
/******/ 	// The chunk loading function for additional chunks
/******/ 	__webpack_require__.e = function requireEnsure(chunkId, callback) {
/******/ 		// "0" is the signal for "already loaded"
/******/ 		if(installedChunks[chunkId] === 0)
/******/ 			return callback.call(null, __webpack_require__);

/******/ 		// an array means "currently loading".
/******/ 		if(installedChunks[chunkId] !== undefined) {
/******/ 			installedChunks[chunkId].push(callback);
/******/ 		} else {
/******/ 			// start chunk loading
/******/ 			installedChunks[chunkId] = [callback];
/******/ 			var head = document.getElementsByTagName('head')[0];
/******/ 			var script = document.createElement('script');
/******/ 			script.type = 'text/javascript';
/******/ 			script.charset = 'utf-8';
/******/ 			script.async = true;

/******/ 			script.src = __webpack_require__.p + "" + chunkId + ".bundle.js";
/******/ 			head.appendChild(script);
/******/ 		}
/******/ 	};

/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/assets/";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	// Our App entry point
	var w8mngr = __webpack_require__(1)
	console.log("w8mngr configuration loaded...")

	// This includes every file in our init directory
	console.log("Loading initialization files...")
	__webpack_require__(6)
	__webpack_require__(9)
	__webpack_require__(11)

	// Run our initializations
	console.log("Initializing w8mngr...")
	w8mngr.init.run()

/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	// Setup the app and its namespaces
	var w8mngr = w8mngr || {}

	// Cookies
	w8mngr.cookies = __webpack_require__(2)

	// Loading toggle(s)
	w8mngr.loading = {}

	// The initialization array
	w8mngr.init = __webpack_require__(3)

	// The Configuration
	w8mngr.config = __webpack_require__(5)

	module.exports = w8mngr

/***/ },
/* 2 */
/***/ function(module, exports) {

	/*\
	|*|
	|*|  :: cookies.js ::
	|*|
	|*|  A complete cookies reader/writer framework with full unicode support.
	|*|
	|*|  Revision #1 - September 4, 2014
	|*|
	|*|  https://developer.mozilla.org/en-US/docs/Web/API/document.cookie
	|*|  https://developer.mozilla.org/User:fusionchess
	|*|
	|*|  This framework is released under the GNU Public License, version 3 or later.
	|*|  http://www.gnu.org/licenses/gpl-3.0-standalone.html
	|*|
	|*|  Syntaxes:
	|*|
	|*|  * docCookies.setItem(name, value[, end[, path[, domain[, secure]]]])
	|*|  * docCookies.getItem(name)
	|*|  * docCookies.removeItem(name[, path[, domain]])
	|*|  * docCookies.hasItem(name)
	|*|  * docCookies.keys()
	|*|
	\*/

	module.exports = {
	  getItem: function (sKey) {
	    if (!sKey) { return null; }
	    return decodeURIComponent(document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*" + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=\\s*([^;]*).*$)|^.*$"), "$1")) || null;
	  },
	  setItem: function (sKey, sValue, vEnd, sPath, sDomain, bSecure) {
	    if (!sKey || /^(?:expires|max\-age|path|domain|secure)$/i.test(sKey)) { return false; }
	    var sExpires = "";
	    if (vEnd) {
	      switch (vEnd.constructor) {
	        case Number:
	          sExpires = vEnd === Infinity ? "; expires=Fri, 31 Dec 9999 23:59:59 GMT" : "; max-age=" + vEnd;
	          break;
	        case String:
	          sExpires = "; expires=" + vEnd;
	          break;
	        case Date:
	          sExpires = "; expires=" + vEnd.toUTCString();
	          break;
	      }
	    }
	    document.cookie = encodeURIComponent(sKey) + "=" + encodeURIComponent(sValue) + sExpires + (sDomain ? "; domain=" + sDomain : "") + (sPath ? "; path=" + sPath : "") + (bSecure ? "; secure" : "");
	    return true;
	  },
	  removeItem: function (sKey, sPath, sDomain) {
	    if (!this.hasItem(sKey)) { return false; }
	    document.cookie = encodeURIComponent(sKey) + "=; expires=Thu, 01 Jan 1970 00:00:00 GMT" + (sDomain ? "; domain=" + sDomain : "") + (sPath ? "; path=" + sPath : "");
	    return true;
	  },
	  hasItem: function (sKey) {
	    if (!sKey) { return false; }
	    return (new RegExp("(?:^|;\\s*)" + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=")).test(document.cookie);
	  },
	  keys: function () {
	    var aKeys = document.cookie.replace(/((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g, "").split(/\s*(?:\=[^;]*)?;\s*/);
	    for (var nLen = aKeys.length, nIdx = 0; nIdx < nLen; nIdx++) { aKeys[nIdx] = decodeURIComponent(aKeys[nIdx]); }
	    return aKeys;
	  }
	};


/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	var forEach = __webpack_require__(4)

	// Our initialization functions

	module.exports = {
	  _toInit: [],
	  add: function(fn) {
	    if (fn instanceof Function) {
	      this._toInit = this._toInit.concat(fn);
	    }
	  },
	  run: function() {
	    forEach(this._toInit, function(fn) {
	      fn()
	    })
	  },
	  // This is a special utility class I use to only declare certan JS functions if
	  // the DOM finds my_app (which should be an ID that corresponds to the app's
	  // el on the Vue instance
	  addIf: function(my_app, fn) {
	    // We attach this to our basic init function so this only loads once
	    // the DOM is known and all of our JS is loaded
	    this.add(function() {
	      if (document.getElementById(my_app) !== null) {
	        fn()
	      }
	    })
	  },
	}

/***/ },
/* 4 */
/***/ function(module, exports) {

	// Very simple looping class I like to use
	module.exports = function(array, fn) {
	  for (var i = 0; i < array.length; i++)
	    fn(array[i], i);
	}

/***/ },
/* 5 */
/***/ function(module, exports) {

	// Our application configuration

	module.exports = {
	  regex: {
	    foodlog_day: /foodlog\/(\d{8})/
	  },
	  resources: {
	    base: "/",
	    search_foods: function(q) {
	      return "/search/foods/?q=" + q
	    },
	    foods: {
	      pull: function(ndbno) {
	        return "/foods/pull/" + ndbno
	      },
	      show: function(id) {
	        return "/foods/" + id
	      }
	    },
	    food_entries: {
	      index: "/food_entries/",
	      add: "/food_entries/",
	      delete: function(id) {
	        return "/food_entries/" + id
	      },
	      from_day: function(day) {
	        return "/foodlog/" + day
	      },
	      update: function(id) {
	        return "/food_entries/" + id
	      }
	    }
	  }
	}

/***/ },
/* 6 */
/***/ function(module, exports, __webpack_require__) {

	var w8mngr = __webpack_require__(1)
	var removeClass = __webpack_require__(7)

	// Initialize all of our apps by removing the nojs tag from the body
	w8mngr.init.add(function() {
	  console.log("Removing the nojs class from the body...")
	  removeClass(document.querySelector('body'), 'nojs')
	})

/***/ },
/* 7 */
/***/ function(module, exports, __webpack_require__) {

	// Basic class manipulation function to remove a class from an element

	var hasClass = __webpack_require__(8)

	module.exports = function(el, className) {
	  if (hasClass(el, className)) {
	    if (el.classList) {
	      el.classList.remove(className)
	    } else {
	      el.className = el.className.replace(new RegExp('(^|\\b)' + className.split(' ')
	        .join('|') + '(\\b|$)', 'gi'), ' ');
	    }
	  }
	}

/***/ },
/* 8 */
/***/ function(module, exports) {

	// Basic class manipulation function for telling if an element has a class

	module.exports = function(el, className) {
	  if (el.classList) {
	    return el.classList.contains(className);
	  } else {
	    return new RegExp('(^| )' + className + '( |$)', 'gi')
	      .test(el.className);
	  }
	}

/***/ },
/* 9 */
/***/ function(module, exports, __webpack_require__) {

	var w8mngr = __webpack_require__(1)
	var forEach = __webpack_require__(4)
	var addEvent = __webpack_require__(10)

	w8mngr.init.add(function() {

		console.log("Loading the navigation...")

		// This function loads the cookies and sets the state of our navigation
		// Dashboard is set as the default menu
		if (w8mngr.cookies.getItem("nav_position") === null) w8mngr.cookies.setItem("nav_position", "#app-menu-dashboard")
		console.log("Current item set at: " + w8mngr.cookies.getItem("nav_position"))

		// Checks our checkbox
		var check_boxes = document.querySelectorAll(w8mngr.cookies.getItem("nav_position"))

		// No checkbox found? Then just bail out of this function
		if(typeof check_boxes[0] === 'undefined') return

		check_boxes[0].checked = true

		// Attaches event listeners to the top-level items
		var nav_boxes = document.querySelectorAll(".app-menu-top-option")
		forEach(nav_boxes, function(el) {
			addEvent(el, "click", function() {
				console.log("Navigation item changed to: " + this.getAttribute("id") + ". Updating cookie.")
				w8mngr.cookies.removeItem("nav_position")
				w8mngr.cookies.setItem("nav_position", "#" + this.getAttribute("id"))
				console.log("Current item set at: " + w8mngr.cookies.getItem("nav_position"))
			})
		})
	})


/***/ },
/* 10 */
/***/ function(module, exports) {

	// Simple event attacher I like to use

	module.exports = function(el, eventName, handler) {
	  if (el.addEventListener) {
	    el.addEventListener(eventName, handler);
	  } else {
	    el.attachEvent("on" + eventName, function() {
	      handler.call(el);
	    });
	  }
	}

/***/ },
/* 11 */
/***/ function(module, exports, __webpack_require__) {

	var w8mngr = __webpack_require__(1)

	w8mngr.init.addIf("food-entries-app", function() {
	  // mount our Vue instance
	  console.log("Loading food-entries-app dependencies...")

	  // Load the following asyncronously
	  __webpack_require__.e/* nsure */(1, function(require) {

	    console.log("Mounting food-entries-app...")

	    var Vue = __webpack_require__(12)
	    Vue.use(__webpack_require__(14))

	    w8mngr.foodEntries = new Vue(__webpack_require__(17))

	    console.log("Vue instance for FoodEntries:")
	    console.log(w8mngr.foodEntries)

	  })
	})

/***/ }
/******/ ]);