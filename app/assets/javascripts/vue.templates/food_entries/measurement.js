w8mngr.foodEntries.templates.measurementItem = `
<div class="measurement" v-bind:class="{ selected: selected }">
  <input type="text" name="amount" v-model="amount" class="amount">
  <div class="unit" alt="Unit" v-text="unit"></div>
  <div class="calories" alt="Calories" v-text="calories"></div>
  <div class="fat" alt="Fat" v-text="fat"></div>
  <div class="carbs" alt="Carbs" v-text="carbs"></div>
  <div class="protein" alt="Protein" v-text="protein"></div>
</div>
`