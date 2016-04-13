w8mngr.foodEntries.templates.main = `
  <div class="day-navigator">
      <a href="#" @click.stop.prevent="loadPrevDay" title="Previous Day"><i class="fa fa-chevron-circle-left"></i></a>
      <span class="current-day" v-text="currentDay"></span>
      <a href="#" @click.stop.prevent="loadNextDay" title="Next Day"><i class="fa fa-chevron-circle-right"></i></a>
  </div>
  <h1><i class="fa fa-cutlery"></i> Food Log</h1>
  <div class="foodlog-table app-form transparent table loading">
    <i class="fa fa-cog fa-spin loading"></i>
    <div class="row header">
      <div class="col long"></div>
      <div class="col" title="Calories">Calories</div>
      <div class="col" title="Fat">Fat</div>
      <div class="col" title="Carbs">Carbs</div>
      <div class="col" title="Protein">Protein</div>
      <div class="col meta"></div>
    </div>
    <div class="row entry" v-for="entry in entries" transition="fade">
      <div class="col long">
        <input type="text" @keyup.enter="saveEntry($index)" v-model="entry.description">
      </div>
      <div class="col short" title="Calories">
        <input type="text" @keyup.enter="saveEntry($index)" v-model="entry.calories">
      </div>
      <div class="col short" title="Fat">
        <input type="text" @keyup.enter="saveEntry($index)" v-model="entry.fat">
      </div>
      <div class="col short" title="Carbs">
        <input type="text" @keyup.enter="saveEntry($index)" v-model="entry.carbs">
      </div>
      <div class="col short" title="Protein">
        <input type="text" @keyup.enter="saveEntry($index)" v-model="entry.protein">
      </div>
      <div class="col meta">
        <a href="#" class="btn delete-btn" title="Delete Entry"  @click.stop.prevent="removeEntry($index)">
          <i class="fa fa-times"></i>
          <span class="screen-reader-text">Delete Entry</span>
        </a>
      </div>
    </div>
    <div class="row header totals">
      <div class="col long">Totals:</div>
      <div class="col" title="Calories" v-text="totalCalories"></div>
      <div class="col" title="Fat" v-text="totalFat"></div>
      <div class="col" title="Carbs" v-text="totalCarbs"></div>
      <div class="col" title="Protein" v-text="totalProtein"></div>
      <div class="col meta"></div>
    </div>
  </div>
  <div class="app-form new table">
    <div class="row new">
      <div class="col long">
        <input type="text"
                @keyup.enter="addEntry"
                @keyup.up="previousAutoCompleteItem"
                @keyup.down="nextAutoCompleteItem"
                @keyup.right="nextMeasurement($event)"
                @keyup.left="previousMeasurement($event)"
                debounce="500"
                v-model="newDescription"
                placeholder="Description" autofocus="autofocus" id="description-input">
      </div>
      <div class="col short" title="Calories">
        <input type="text" @keyup.enter="addEntry" v-model="newCalories" placeholder="Calories">
      </div>
      <div class="col short" title="Fat">
        <input type="text" @keyup.enter="addEntry" v-model="newFat" placeholder="Fat">
      </div>
      <div class="col short" title="Carbs">
        <input type="text" @keyup.enter="addEntry" v-model="newCarbs" placeholder="Carbs">
      </div>
      <div class="col short" title="Protein">
        <input type="text" @keyup.enter="addEntry" v-model="newProtein" placeholder="Protein">
      </div>
      <div class="col meta">
        <a class="btn barcode-btn" alt="Scan Barcode" title="Scan Barcode" href="<%= food_search_path %>">
          <i class="fa fa-barcode"></i>
          <span class="screen-reader-text">Scan Barcode</span>
        </a>
        <a class="btn search-btn" alt="Search for Foods" title="Search for Foods" href="<%= food_search_path :food_log_referrer => "true"%>">
          <i class="fa fa-search"></i>
          <span class="screen-reader-text">Search for Foods</span>
        </a>
        <button name="button" type="submit" class="btn food-log-new-btn" @click.stop.prevent="addEntry">
          <i class="fa fa-plus"></i>
          <strong>New Entry</strong>
        </button>
      </div>
    </div>
  </div>
  <div class="autocomplete-results">
    <div class="autocomplete-item"
         v-for="item in autoCompleteItems"
         id="{{ item.domId }}"
         @click="autoCompleteSelectItem($index)">
      <h3 v-text="item.name" class="name"></h3>
      <p v-text="item.description" class="description"></p>
      <div class="measurements">
        <div class="measurement"
             v-for="measurement in item.measurements"
             id="measurement-{{ $parent.$index }}-{{ measurement.id }}">
          <input type="text" name="amount" v-model="measurement.amount" class="amount">
          <div class="unit" alt="Unit" v-text="measurement.unit"></div>
          <div class="calories" alt="Calories" v-text="measurement.calories"></div>
          <div class="fat" alt="Fat" v-text="measurement.fat"></div>
          <div class="carbs" alt="Carbs" v-text="measurement.carbs"></div>
          <div class="protein" alt="Protein" v-text="measurement.protein"></div>
        </div>
      </div>
    </div>
  </div>
  `;