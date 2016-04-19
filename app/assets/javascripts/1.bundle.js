webpackJsonp([1],[
/* 0 */,
/* 1 */,
/* 2 */,
/* 3 */,
/* 4 */,
/* 5 */,
/* 6 */,
/* 7 */,
/* 8 */,
/* 9 */,
/* 10 */,
/* 11 */,
/* 12 */,
/* 13 */,
/* 14 */
/*!******************************************************!*\
  !*** ./app/frontend/javascripts/vue/FoodEntries.vue ***!
  \******************************************************/
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(/*! !babel-loader?presets[]=es2015&plugins[]=transform-runtime&comments=false!./FoodEntries/FoodEntries.js */ 15)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] app/frontend/javascripts/vue/FoodEntries.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(/*! !vue-html-loader!./FoodEntries/FoodEntries.html */ 26)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/ubuntu/workspace/app/frontend/javascripts/vue/FoodEntries.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 15 */
/*!**********************************************************************************************************************************************!*\
  !*** ./~/babel-loader?presets[]=es2015&plugins[]=transform-runtime&comments=false!./app/frontend/javascripts/vue/FoodEntries/FoodEntries.js ***!
  \**********************************************************************************************************************************************/
/***/ function(module, exports, __webpack_require__) {

	'use strict';
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	var _AutocompleteItem = __webpack_require__(/*! ../AutocompleteItem.vue */ 16);
	
	var _AutocompleteItem2 = _interopRequireDefault(_AutocompleteItem);
	
	var _FoodEntry = __webpack_require__(/*! ../FoodEntry.vue */ 22);
	
	var _FoodEntry2 = _interopRequireDefault(_FoodEntry);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }
	
	var parseTotals = __webpack_require__(/*! ../../fn/parseTotals.js */ 25);
	
	exports.default = {
	  el: "#food-entries-app",
	  events: {
	    'hook:ready': function hookReady() {
	      this.initializeApp();
	    },
	    'fillin-form': function fillinForm(data) {
	      this.newDescriptionTemp = data.description;
	      this.newCalories = data.calories;
	      this.newFat = data.fat;
	      this.newCarbs = data.carbs;
	      this.newProtein = data.protein;
	    },
	    'next-measurement': function nextMeasurement() {
	      this.nextMeasurement();
	    },
	    'previous-measurement': function previousMeasurement() {
	      this.previousMeasurement();
	    },
	    'add-entry': function addEntry() {
	      this.addEntry();
	    }
	  },
	  data: {
	    currentDayNumber: '',
	    currentDay: '',
	    prevDay: '',
	    nextDay: '',
	    newDescription: '',
	
	    newDescriptionTemp: null,
	    newCalories: '',
	    newFat: '',
	    newCarbs: '',
	    newProtein: '',
	    totalCalories: '',
	    totalFat: '',
	    totalCarbs: '',
	    totalProtein: '',
	    entries: [],
	    autoCompleteItems: [],
	    autoCompleteSelected: -1,
	    autoCompleteLoading: 0
	  },
	  components: {
	    AutocompleteItem: _AutocompleteItem2.default,
	    FoodEntry: _FoodEntry2.default
	  },
	  methods: {
	    initializeApp: function initializeApp() {
	      console.log("Initializing the FoodEntries app...");
	
	      var find_day = w8mngr.config.regex.foodlog_day.exec(window.location.href);
	      var day = "";
	      try {
	        day = find_day[1];
	      } catch (e) {}
	
	      this.loadDay(day);
	
	      this.$watch("newDescription", function (searchTerm) {
	        this.autoComplete(searchTerm);
	      });
	    },
	
	    addEntry: function addEntry() {
	
	      w8mngr.loading.on();
	
	      var description = this.newDescriptionTemp || this.newDescription.trim();
	      var calories = parseInt(this.newCalories) || 0;
	      var fat = parseInt(this.newFat) || 0;
	      var carbs = parseInt(this.newCarbs) || 0;
	      var protein = parseInt(this.newProtein) || 0;
	
	      var data = {
	        description: description,
	        calories: calories,
	        fat: fat,
	        carbs: carbs,
	        protein: protein
	      };
	
	      if (description) {
	        this.newDescription = '';
	        this.newDescriptionTemp = null;
	        this.newCalories = '';
	        this.newFat = '';
	        this.newCarbs = '';
	        this.newProtein = '';
	        this.autoCompleteItems = [];
	
	        var data_to_send = data;
	        data.id = null;
	        var index = this.entries.push(data) - 1;
	
	        var app = this;
	
	        data_to_send = {
	          food_entry: data_to_send
	        };
	        data_to_send.food_entry.day = this.currentDayNumber;
	
	        w8mngr.fetch({
	          method: "POST",
	          url: w8mngr.config.resources.food_entries.add,
	          data: data_to_send,
	          onSuccess: function onSuccess(response) {
	            if (response.success === false) {
	              w8mngr.loading.off();
	              alert("Unknown error...");
	            } else {
	              app.entries[index].id = parseInt(response.success);
	              w8mngr.loading.off();
	            }
	          },
	          onError: function onError(response) {
	            alert("ERROR: " + response);
	          }
	        });
	        this.calculateTotals();
	        document.getElementById("description-input").focus();
	      } else {
	        document.getElementById("description-input").focus();
	      }
	    },
	
	    calculateTotals: function calculateTotals() {
	      this.totalCalories = w8mngr.fn.parseTotals(this.entries, 'calories');
	      this.totalFat = w8mngr.fn.parseTotals(this.entries, 'fat');
	      this.totalCarbs = w8mngr.fn.parseTotals(this.entries, 'carbs');
	      this.totalProtein = w8mngr.fn.parseTotals(this.entries, 'protein');
	    },
	
	    loadNextDay: function loadNextDay() {
	      this.loadDay(this.nextDay);
	    },
	
	    loadPrevDay: function loadPrevDay() {
	      this.loadDay(this.prevDay);
	    },
	
	    loadDay: function loadDay() {
	      var day = arguments.length <= 0 || arguments[0] === undefined ? "" : arguments[0];
	
	      w8mngr.loading.on();
	      console.log("Fetching data from the API...");
	      w8mngr.state.push({}, w8mngr.config.resources.food_entries.from_day(day));
	      var app = this;
	      w8mngr.fetch({
	        method: "GET",
	        url: w8mngr.config.resources.food_entries.from_day(day),
	        onSuccess: function onSuccess(response) {
	          app.entries = response.entries;
	          app.currentDayNumber = response.current_day;
	          app.calculateTotals();
	          app.parseDays();
	          w8mngr.loading.off();
	        },
	        onError: function onError(response) {
	          alert("ERROR:" + response);
	        }
	      });
	    },
	
	    parseDays: function parseDays() {
	      this.currentDay = w8mngr.fn.numberToDay(this.currentDayNumber);
	      this.prevDay = w8mngr.fn.yesterdayNumber(this.currentDayNumber);
	      this.nextDay = w8mngr.fn.tomorrowNumber(this.currentDayNumber);
	      console.log("Parsed previous day: " + this.prevDay + " -- And next day: " + this.nextDay);
	    },
	
	    autoComplete: function autoComplete(query) {
	      if (query.length <= 3) return false;
	
	      this.autoCompleteLoading = 1;
	      var app = this;
	      w8mngr.fetch({
	        method: "get",
	        url: w8mngr.config.resources.search_foods(query),
	        onSuccess: function onSuccess(response) {
	          if (response.success === false) {
	            alert("Unknown error...");
	            app.autoCompleteLoading = 0;
	          } else {
	            app.formatAutoCompleteResults(response);
	            app.autoCompleteLoading = 0;
	          }
	        },
	        onError: function onError(response) {
	          alert("ERROR: " + response);
	          app.autoCompleteLoading = 0;
	        }
	      });
	    },
	    formatAutoCompleteResults: function formatAutoCompleteResults(response) {
	      console.log("Parsing autocomplete items");
	      this.autoCompleteItems = [];
	      this.autoCompleteSelected = -1;
	      console.log(response.results);
	      if (response.results.length > 0) {
	        var self = this;
	        w8mngr.fn.forEach(response.results, function (result, i) {
	          var resource = "offset" in result && "group" in result ? w8mngr.config.resources.foods.pull(result.ndbno) : w8mngr.config.resources.foods.show(result.id);
	          self.autoCompleteItems.push({
	            name: result.name,
	            resource: resource,
	            measurements: [],
	            measurementsLoaded: 0,
	            selectedMeasurement: 0
	          });
	        });
	      }
	    },
	
	    nextAutoCompleteItem: function nextAutoCompleteItem() {
	      if (this.autoCompleteItems.length < 1) return false;
	      if (this.autoCompleteSelected == this.autoCompleteItems.length - 1) return false;
	
	      console.log("Down: " + (this.autoCompleteSelected + 1));
	
	      this.autoCompleteSelected = this.autoCompleteSelected + 1;
	    },
	
	    previousAutoCompleteItem: function previousAutoCompleteItem() {
	      if (this.autoCompleteItems.length < 1) return false;
	      if (this.autoCompleteSelected < 0) return false;
	
	      console.log("Up: " + (this.autoCompleteSelected - 1));
	
	      if (this.autoCompleteSelected >= 0) {
	        this.autoCompleteSelected = this.autoCompleteSelected - 1;
	      }
	    },
	
	    nextMeasurement: function nextMeasurement(e) {
	      if (this.autoCompleteSelected == -1) return false;
	
	      var item = this.autoCompleteItems[this.autoCompleteSelected];
	
	      if (item.selectedMeasurement == item.measurements.length - 1) return false;
	
	      item.selectedMeasurement = item.selectedMeasurement + 1;
	      console.log("Selected next item: " + item.selectedMeasurement);
	    },
	
	    previousMeasurement: function previousMeasurement() {
	      if (this.autoCompleteSelected == -1) return false;
	
	      var item = this.autoCompleteItems[this.autoCompleteSelected];
	
	      if (item.selectedMeasurement == 0) return false;
	
	      item.selectedMeasurement = item.selectedMeasurement - 1;
	      console.log("Selected previous item: " + item.selectedMeasurement);
	    }
	  }
	};

/***/ },
/* 16 */
/*!***********************************************************!*\
  !*** ./app/frontend/javascripts/vue/AutocompleteItem.vue ***!
  \***********************************************************/
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(/*! !babel-loader?presets[]=es2015&plugins[]=transform-runtime&comments=false!./AutocompleteItem/AutocompleteItem.js */ 17)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] app/frontend/javascripts/vue/AutocompleteItem.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(/*! !vue-html-loader!./AutocompleteItem/AutocompleteItem.html */ 21)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/ubuntu/workspace/app/frontend/javascripts/vue/AutocompleteItem.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 17 */
/*!********************************************************************************************************************************************************!*\
  !*** ./~/babel-loader?presets[]=es2015&plugins[]=transform-runtime&comments=false!./app/frontend/javascripts/vue/AutocompleteItem/AutocompleteItem.js ***!
  \********************************************************************************************************************************************************/
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	var _AutocompleteMeasurement = __webpack_require__(/*! ../AutocompleteMeasurement.vue */ 18);
	
	var _AutocompleteMeasurement2 = _interopRequireDefault(_AutocompleteMeasurement);
	
	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }
	
	exports.default = {
	  components: {
	    AutocompleteMeasurement: _AutocompleteMeasurement2.default
	  },
	  props: ["index", "name", "resource", "description", "measurementsLoaded", "measurements", "selectedMeasurement", "autoCompleteLoading"],
	  events: {
	    'hook:ready': function hookReady() {
	      this.initializeComponent();
	    }
	  },
	  methods: {
	    addEntry: function addEntry() {
	      this.$dispatch('add-entry');
	    },
	    initializeComponent: function initializeComponent() {
	      this.autoCompleteLoading = 0;
	
	      this.$watch("$parent.autoCompleteSelected", function (index) {
	        if (index == this.index) this.loadItemData();
	      });
	    },
	    loadItemData: function loadItemData() {
	      if (this.measurementsLoaded) return false;
	
	      this.autoCompleteLoading = 1;
	
	      var in_cache = w8mngr.cache.get("food", this.resource);
	
	      if (in_cache !== null) {
	        console.log("Item found in the cache for " + this.name + ". Loading it into Vue.");
	        this.measurements = in_cache.measurements;
	        this.measurementsLoaded = 1;
	        this.autoCompleteLoading = 0;
	        return true;
	      }
	
	      console.log("Loading item data for: " + this.index);
	
	      var self = this;
	
	      w8mngr.fetch({
	        method: "get",
	        url: self.resource,
	        onSuccess: function onSuccess(response) {
	          self.autoCompleteLoading = 0;
	          if (response.success === false) {
	            alert("Unknown error...");
	          } else {
	            self.measurements = response.measurements;
	            self.description = response.description;
	            self.measurementsLoaded = 1;
	            w8mngr.cache.set("food", self.resource, {
	              id: self.id,
	              name: self.name,
	              description: self.description,
	              measurements: self.measurements
	            });
	
	            self.selectedMeasurement = 0;
	          }
	        },
	        onError: function onError(response) {
	          alert("ERROR: " + response);
	        }
	      });
	    }
	  },
	  computed: {
	    selected: function selected() {
	      if (this.$parent.autoCompleteSelected == this.index) return true;
	      return false;
	    }
	  }
	};

/***/ },
/* 18 */
/*!******************************************************************!*\
  !*** ./app/frontend/javascripts/vue/AutocompleteMeasurement.vue ***!
  \******************************************************************/
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(/*! !babel-loader?presets[]=es2015&plugins[]=transform-runtime&comments=false!./AutocompleteMeasurement/AutocompleteMeasurement.js */ 19)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] app/frontend/javascripts/vue/AutocompleteMeasurement.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(/*! !vue-html-loader!./AutocompleteMeasurement/AutocompleteMeasurement.html */ 20)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/ubuntu/workspace/app/frontend/javascripts/vue/AutocompleteMeasurement.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 19 */
/*!**********************************************************************************************************************************************************************!*\
  !*** ./~/babel-loader?presets[]=es2015&plugins[]=transform-runtime&comments=false!./app/frontend/javascripts/vue/AutocompleteMeasurement/AutocompleteMeasurement.js ***!
  \**********************************************************************************************************************************************************************/
/***/ function(module, exports) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.default = {
	  props: ["index", "amount", "unit", "calories", "fat", "carbs", "protein", "selectedMeasurement", "newAmount"],
	  events: {
	    'hook:ready': function hookReady() {
	      this.newAmount = this.amount;
	    }
	  },
	  methods: {
	    nextMeasurement: function nextMeasurement() {
	      this.$dispatch('next-measurement');
	    },
	
	    previousMeasurement: function previousMeasurement() {
	      this.$dispatch('previous-measurement');
	    },
	
	    addEntry: function addEntry() {
	      this.$dispatch('add-entry');
	    },
	
	    dispatchMeasurementInfo: function dispatchMeasurementInfo() {
	      var data = {
	        description: this.amount + " " + this.unit + " " + this.$parent.name,
	        calories: this.cCalories,
	        fat: this.cFat,
	        carbs: this.cCarbs,
	        protein: this.cProtein
	      };
	      this.$dispatch('fillin-form', data);
	    }
	  },
	  computed: {
	    selected: function selected() {
	      if (this.selectedMeasurement == this.index) {
	        this.dispatchMeasurementInfo();
	        return true;
	      }
	      return false;
	    },
	    cAmount: function cAmount() {
	      var multiplier = parseFloat(this.newAmount / this.amount);
	      if (isNaN(multiplier)) return multiplier;
	      return this.amount;
	    },
	    cCalories: function cCalories() {
	      return Math.ceil(this.calories * this.cAmount);
	    },
	    cFat: function cFat() {
	      return Math.ceil(this.fat * this.cAmount);
	    },
	    cCarbs: function cCarbs() {
	      return Math.ceil(this.carbs * this.cAmount);
	    },
	    cProtein: function cProtein() {
	      return Math.ceil(this.protein * this.cAmount);
	    }
	  }
	};

/***/ },
/* 20 */
/*!***************************************************************************************************************!*\
  !*** ./~/vue-html-loader!./app/frontend/javascripts/vue/AutocompleteMeasurement/AutocompleteMeasurement.html ***!
  \***************************************************************************************************************/
/***/ function(module, exports) {

	module.exports = "<div class=\"measurement\" v-bind:class=\"{ selected: selected }\">\n  <div class=\"previous-measurement\" @click.stop.prevent=\"previousMeasurement()\">\n    <i class=\"fa fa-arrow-left\" aria-hidden=\"true\"></i>\n    <span class=\"screen-reader-text\">Previous Measurement</span>\n  </div>\n  <input type=\"text\" name=\"amount\" class=\"amount\"\n    v-model=\"newAmount\"\n    @keyup.enter=\"addEntry()\"\n    @keyup.left.stop.prevent=\"previousMeasurement()\"\n    @keyup.right.stop.prevent=\"nextMeasurement()\">\n  <div class=\"unit\" alt=\"Unit\" v-text=\"unit\"></div>\n  <div class=\"calories\" alt=\"Calories\" v-text=\"cCalories\"></div>\n  <div class=\"fat\" alt=\"Fat\" v-text=\"cFat\"></div>\n  <div class=\"carbs\" alt=\"Carbs\" v-text=\"cCarbs\"></div>\n  <div class=\"protein\" alt=\"Protein\" v-text=\"cProtein\"></div>\n  <div class=\"next-measurement\" @click.stop.prevent=\"nextMeasurement()\">\n    <i class=\"fa fa-arrow-right\" aria-hidden=\"true\"></i>\n    <span class=\"screen-reader-text\">Next Measurement</span>\n  </div>\n</div>";

/***/ },
/* 21 */
/*!*************************************************************************************************!*\
  !*** ./~/vue-html-loader!./app/frontend/javascripts/vue/AutocompleteItem/AutocompleteItem.html ***!
  \*************************************************************************************************/
/***/ function(module, exports) {

	module.exports = "<div class=\"autocomplete-item\"\n     v-bind:class=\"{ selected: selected }\"\n     @click=\"$parent.autoCompleteSelected = index\">\n  <h3 class=\"name\">\n    <a class=\"add-food\" @click.stop.prevent=\"addEntry()\" v-if=\"measurements\">\n      <i class=\"fa fa-plus-circle\" aria-hidden=\"true\"></i>\n      <span class=\"screen-reader-text\">Add Entry</span>\n    </a>\n    {{ name }}\n  </h3>\n  <p v-text=\"description\" class=\"description\" v-if=\"description\"></p>\n  <div class=\"small-loader\" v-if=\"autoCompleteLoading\">\n    <i class=\"fa fa-cog fa-spin\"></i>\n    <span class=\"screen-reader-text\">Loading...</span>\n  </div>\n  <div class=\"measurements\">\n    <measurement-item v-for=\"measurement in measurements\"\n                 :index=\"$index\"\n                 :amount=\"measurement.amount\"\n                 :unit=\"measurement.unit\"\n                 :calories=\"measurement.calories\"\n                 :fat=\"measurement.fat\"\n                 :carbs=\"measurement.carbs\"\n                 :protein=\"measurement.protein\"\n                 :selected-measurement=\"selectedMeasurement\"></measurement-item>\n  </div>\n</div>";

/***/ },
/* 22 */
/*!****************************************************!*\
  !*** ./app/frontend/javascripts/vue/FoodEntry.vue ***!
  \****************************************************/
/***/ function(module, exports, __webpack_require__) {

	var __vue_script__, __vue_template__
	__vue_script__ = __webpack_require__(/*! !babel-loader?presets[]=es2015&plugins[]=transform-runtime&comments=false!./FoodEntry/FoodEntry.js */ 23)
	if (__vue_script__ &&
	    __vue_script__.__esModule &&
	    Object.keys(__vue_script__).length > 1) {
	  console.warn("[vue-loader] app/frontend/javascripts/vue/FoodEntry.vue: named exports in *.vue files are ignored.")}
	__vue_template__ = __webpack_require__(/*! !vue-html-loader!./FoodEntry/FoodEntry.html */ 24)
	module.exports = __vue_script__ || {}
	if (module.exports.__esModule) module.exports = module.exports.default
	if (__vue_template__) {
	(typeof module.exports === "function" ? (module.exports.options || (module.exports.options = {})) : module.exports).template = __vue_template__
	}
	if (false) {(function () {  module.hot.accept()
	  var hotAPI = require("vue-hot-reload-api")
	  hotAPI.install(require("vue"), true)
	  if (!hotAPI.compatible) return
	  var id = "/home/ubuntu/workspace/app/frontend/javascripts/vue/FoodEntry.vue"
	  if (!module.hot.data) {
	    hotAPI.createRecord(id, module.exports)
	  } else {
	    hotAPI.update(id, module.exports, __vue_template__)
	  }
	})()}

/***/ },
/* 23 */
/*!******************************************************************************************************************************************!*\
  !*** ./~/babel-loader?presets[]=es2015&plugins[]=transform-runtime&comments=false!./app/frontend/javascripts/vue/FoodEntry/FoodEntry.js ***!
  \******************************************************************************************************************************************/
/***/ function(module, exports) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.default = {
	  props: ["id", "index", "description", "calories", "fat", "carbs", "protein"],
	  methods: {
	    removeEntry: function removeEntry(index) {
	      w8mngr.loading.on();
	      var self = this;
	      w8mngr.fetch({
	        method: "DELETE",
	        url: w8mngr.config.resources.food_entries.delete(self.id),
	        onSuccess: function onSuccess(response) {
	          if (response.success === true) {
	            self.$parent.entries.splice(self.index, 1);
	            self.$parent.calculateTotals();
	            w8mngr.loading.off();
	          } else {
	            alert("Unknown error...");
	          }
	        },
	        onError: function onError(response) {
	          alert("ERROR: " + response);
	        }
	      });
	    },
	
	    saveEntry: function saveEntry(index) {
	      w8mngr.loading.on();
	      this.$parent.calculateTotals();
	
	      var data = {
	        food_entry: {
	          description: this.description,
	          calories: this.calories,
	          fat: this.fat,
	          carbs: this.carbs,
	          protein: this.protein
	        }
	      };
	
	      var self = this;
	      w8mngr.fetch({
	        method: "PATCH",
	        url: w8mngr.config.resources.food_entries.update(self.id),
	        data: data,
	        onSuccess: function onSuccess(response) {
	          if (response.success == true) {
	            w8mngr.loading.off();
	          } else {
	            alert("Unknown error...");
	          }
	        },
	        onError: function onError(response) {
	          alert("ERROR:" + response);
	        }
	      });
	    }
	  }
	};

/***/ },
/* 24 */
/*!***********************************************************************************!*\
  !*** ./~/vue-html-loader!./app/frontend/javascripts/vue/FoodEntry/FoodEntry.html ***!
  \***********************************************************************************/
/***/ function(module, exports) {

	module.exports = "<div class=\"row entry\" transition=\"fl-fade\">\n  <div class=\"col long\">\n    <input type=\"text\" @keyup.enter=\"saveEntry(index)\" v-model=\"description\">\n  </div>\n  <div class=\"col short\" title=\"Calories\">\n    <input type=\"text\" @keyup.enter=\"saveEntry(index)\" v-model=\"calories\">\n  </div>\n  <div class=\"col short\" title=\"Fat\">\n    <input type=\"text\" @keyup.enter=\"saveEntry(index)\" v-model=\"fat\">\n  </div>\n  <div class=\"col short\" title=\"Carbs\">\n    <input type=\"text\" @keyup.enter=\"saveEntry(index)\" v-model=\"carbs\">\n  </div>\n  <div class=\"col short\" title=\"Protein\">\n    <input type=\"text\" @keyup.enter=\"saveEntry(index)\" v-model=\"protein\">\n  </div>\n  <div class=\"col meta\">\n    <a href=\"#\" class=\"btn delete-btn\" title=\"Delete Entry\"\n      @click.stop.prevent=\"removeEntry(index)\"\n      v-if=\"id\">\n      <i class=\"fa fa-times\"></i>\n      <span class=\"screen-reader-text\">Delete Entry</span>\n    </a>\n  </div>\n</div>";

/***/ },
/* 25 */
/*!****************************************************!*\
  !*** ./app/frontend/javascripts/fn/parseTotals.js ***!
  \****************************************************/
/***/ function(module, exports, __webpack_require__) {

	var forEach  = __webpack_require__(/*! ./forEach.js */ 4)
	
	// A utility function for calculating our calories, fat, carbs, and proteins
	
	module.exports = function(array, element) {
	  var sum = 0
	  forEach(array, function(entry) {
	    sum = sum + parseInt(entry[element], 10)
	  })
	  return sum
	}

/***/ },
/* 26 */
/*!***************************************************************************************!*\
  !*** ./~/vue-html-loader!./app/frontend/javascripts/vue/FoodEntries/FoodEntries.html ***!
  \***************************************************************************************/
/***/ function(module, exports) {

	module.exports = "<template>\n  <div class=\"day-navigator\">\n      <a href=\"#\" @click.stop.prevent=\"loadPrevDay\" title=\"Previous Day\"><i class=\"fa fa-chevron-circle-left\"></i></a>\n      <span class=\"current-day\" v-text=\"currentDay\"></span>\n      <a href=\"#\" @click.stop.prevent=\"loadNextDay\" title=\"Next Day\"><i class=\"fa fa-chevron-circle-right\"></i></a>\n  </div>\n  <h1><i class=\"fa fa-cutlery\"></i> Food Log</h1>\n  <div class=\"foodlog-table app-form transparent table loading\">\n    <i class=\"fa fa-cog fa-spin loading\"></i>\n    <div class=\"row header\">\n      <div class=\"col long\"></div>\n      <div class=\"col\" title=\"Calories\">Calories</div>\n      <div class=\"col\" title=\"Fat\">Fat</div>\n      <div class=\"col\" title=\"Carbs\">Carbs</div>\n      <div class=\"col\" title=\"Protein\">Protein</div>\n      <div class=\"col meta\"></div>\n    </div>\n    <food-entry v-for=\"entry in entries\"\n                :id=\"entry.id\"\n                :index=\"$index\"\n                :description=\"entry.description\"\n                :calories=\"entry.calories\"\n                :fat=\"entry.fat\"\n                :carbs=\"entry.carbs\"\n                :protein=\"entry.protein\"></food-entry>\n    <p v-if=\"entries.length < 1\">You have not logged any entries today. Add some via the form below!</p>\n    <div class=\"row header totals\" v-if=\"totalCalories > 0\">\n      <div class=\"col long\">Totals:</div>\n      <div class=\"col\" title=\"Calories\" v-text=\"totalCalories\"></div>\n      <div class=\"col\" title=\"Fat\" v-text=\"totalFat\"></div>\n      <div class=\"col\" title=\"Carbs\" v-text=\"totalCarbs\"></div>\n      <div class=\"col\" title=\"Protein\" v-text=\"totalProtein\"></div>\n      <div class=\"col meta\"></div>\n    </div>\n  </div>\n  <div class=\"app-form new table\">\n    <div class=\"row new\">\n      <div class=\"col long\">\n        <input type=\"text\"\n                @keyup.enter=\"addEntry\"\n                @keyup.up=\"previousAutoCompleteItem\"\n                @keyup.down=\"nextAutoCompleteItem\"\n                @keyup.right=\"nextMeasurement($event)\"\n                @keyup.left=\"previousMeasurement($event)\"\n                debounce=\"500\"\n                v-model=\"newDescription\"\n                placeholder=\"Description\" autofocus=\"autofocus\" id=\"description-input\">\n      </div>\n      <div class=\"col short\" title=\"Calories\">\n        <input type=\"text\" @keyup.enter=\"addEntry\" v-model=\"newCalories\" placeholder=\"Calories\">\n      </div>\n      <div class=\"col short\" title=\"Fat\">\n        <input type=\"text\" @keyup.enter=\"addEntry\" v-model=\"newFat\" placeholder=\"Fat\">\n      </div>\n      <div class=\"col short\" title=\"Carbs\">\n        <input type=\"text\" @keyup.enter=\"addEntry\" v-model=\"newCarbs\" placeholder=\"Carbs\">\n      </div>\n      <div class=\"col short\" title=\"Protein\">\n        <input type=\"text\" @keyup.enter=\"addEntry\" v-model=\"newProtein\" placeholder=\"Protein\">\n      </div>\n      <div class=\"col meta\">\n        <a class=\"btn barcode-btn\" alt=\"Scan Barcode\" title=\"Scan Barcode\" href=\"<%= Rails.application.routes.url_helpers.food_search_path %>\">\n          <i class=\"fa fa-barcode\"></i>\n          <span class=\"screen-reader-text\">Scan Barcode</span>\n        </a>\n        <a class=\"btn search-btn\" alt=\"Search for Foods\" title=\"Search for Foods\" href=\"<%= Rails.application.routes.url_helpers.food_search_path :food_log_referrer => \"true\"%>\">\n          <i class=\"fa fa-search\"></i>\n          <span class=\"screen-reader-text\">Search for Foods</span>\n        </a>\n        <button name=\"button\" type=\"submit\" class=\"btn food-log-new-btn\" @click.stop.prevent=\"addEntry\">\n          <i class=\"fa fa-plus\"></i>\n          <strong>New Entry</strong>\n        </button>\n      </div>\n    </div>\n  </div>\n  <div class=\"autocomplete-results\">\n    <div class=\"auto-complete-loading\">\n      <div class=\"small-loader\" v-if=\"autoCompleteLoading\">\n        <i class=\"fa fa-cog fa-spin\"></i>\n        <span class=\"screen-reader-text\">Loading...</span>\n      </div>\n      <div class=\"message\" v-if=\"!autoCompleteLoading && newDescription.length > 3 && autoCompleteItems.length < 1\">\n        <p>No items were found matching <em>{{ newDescription }}</em></p>\n      </div>\n      <div class=\"message\" v-if=\"!autoCompleteLoading && newDescription.length <= 3\">\n        <p> Enter text in the description fied to load items here that you can easily\n            add to your log! Once there is a list of foods here, use either your\n            mouse or the arrow keys to navigate the items.</p>\n      </div>\n    </div>\n    <autocomplete-item v-for=\"item in autoCompleteItems\"\n                       :index=\"$index\"\n                       :name=\"item.name\"\n                       :description.sync=\"item.description\"\n                       :resource=\"item.resource\"\n                       :measurements-loaded.sync=\"item.measurementsLoaded\"\n                       :selected-measurement.sync=\"item.selectedMeasurement\"\n                       :measurements.sync=\"item.measurements\"\n                       transition=\"ac-fade\" stagger=\"25\"></autocomplete-item>\n  </div>\n</template>";

/***/ },
/* 27 */
/*!*******************************************************!*\
  !*** ./app/frontend/javascripts/vue/plugins/fetch.js ***!
  \*******************************************************/
/***/ function(module, exports) {

	var w8mngrFetch = {}
	
	w8mngrFetch.fetch = function(options) {
	  var method = options.method
	    // This makes sure the async_seed adds an additional variable if there are
	    // already variables in the URL, or as the only variable if there aren't
	    // And we add the async_seed to prevent caching
	  var sep = (options.url.indexOf("?") == -1) ? "?" : "&"
	  var url = options.url + sep + "async_seed=" + new Date()
	    .getTime()
	  var onSuccess = (options.onSuccess instanceof Function) ? options.onSuccess : null
	  var onError = (options.onError instanceof Function) ? options.onError : null
	
	  var request = new XMLHttpRequest();
	  console.log("Launching " + method + " request to " + url)
	  request.open(method, url, true);
	  if (onSuccess !== null || onError !== null) {
	    console.log("Attaching callback  to the " + method + " request...")
	    request.onreadystatechange = function() {
	      if (this.readyState === 4) {
	        console.log(method + " request returned " + this.readyState + "...")
	        if (this.status >= 200 && this.status < 400) {
	          // Success!
	          if (onSuccess !== null) onSuccess(JSON.parse(this.responseText));
	        } else {
	          // Error :(
	          if (onError !== null) onError(this.status, this.error, this.responseText);
	        }
	      }
	    };
	  }
	  request.setRequestHeader("Accept", "application/json")
	  if (method == "POST" || method == "PUT" || method == "PATCH") {
	    var data = JSON.stringify(options.data);
	    console.log("Sending: " + data)
	    request.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
	    request.send(data);
	  } else {
	    request.setRequestHeader("Content-Type", "application/json");
	    request.send();
	  }
	  request = null;
	}
	
	w8mngrFetch.install = function(externalVue, options) {
	  externalVue.fetch = this.fetch
	  externalVue.fetchResources = options.resources
	}
	
	module.exports = w8mngrFetch

/***/ },
/* 28 */
/*!*******************************************************!*\
  !*** ./app/frontend/javascripts/vue/plugins/cache.js ***!
  \*******************************************************/
/***/ function(module, exports) {

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

/***/ }
]);
//# sourceMappingURL=1.bundle.js.map