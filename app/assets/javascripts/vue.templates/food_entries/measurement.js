w8mngr.foodEntries.templates.measurementItem = `
<div class="measurement" v-bind:class="{ selected: selected }">
  <input type="text" name="amount" v-model="newAmount" class="amount">
  <div class="unit" alt="Unit" v-text="unit"></div>
  <div class="calories" alt="Calories" v-text="cCalories"></div>
  <div class="fat" alt="Fat" v-text="cFat"></div>
  <div class="carbs" alt="Carbs" v-text="cCarbs"></div>
  <div class="protein" alt="Protein" v-text="cProtein"></div>
</div>
`