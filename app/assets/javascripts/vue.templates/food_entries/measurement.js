w8mngr.foodEntries.templates.measurementItem = `
<div class="measurement" v-bind:class="{ selected: selected }">
  <div class="previous-measurement" @click.stop.prevent="previousMeasurement()">
    <i class="fa fa-arrow-left" aria-hidden="true"></i>
    <span class="screen-reader-text">Previous Measurement</span>
  </div>
  <input type="text" name="amount" class="amount"
    v-model="newAmount"
    @keyup.enter="addEntry()"
    @keyup.left.stop.prevent="previousMeasurement()"
    @keyup.right.stop.prevent="nextMeasurement()">
  <div class="unit" alt="Unit" v-text="unit"></div>
  <div class="calories" alt="Calories" v-text="cCalories"></div>
  <div class="fat" alt="Fat" v-text="cFat"></div>
  <div class="carbs" alt="Carbs" v-text="cCarbs"></div>
  <div class="protein" alt="Protein" v-text="cProtein"></div>
  <div class="next-measurement" @click.stop.prevent="nextMeasurement()">
    <i class="fa fa-arrow-right" aria-hidden="true"></i>
    <span class="screen-reader-text">Next Measurement</span>
  </div>
</div>
`