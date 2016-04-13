w8mngr.foodEntries.templates.autoCompleteItem = `
<div class="autocomplete-item"
     v-bind:class="{ selected: selected }"
     @click="$parent.autoCompleteSelected = index">
  <h3 v-text="name" class="name"></h3>
  <p v-text="description" class="description" v-if="description"></p>
  <div class="measurements">
    <measurement-item v-for="measurement in measurements"
                 :index="$index"
                 :amount="measurement.amount"
                 :unit="measurement.unit"
                 :calories="measurement.calories"
                 :fat="measurement.fat"
                 :carbs="measurement.carbs"
                 :protein="measurement.protein"
                 :selected-measurement="selectedMeasurement"></measurement-item>
  </div>
</div>
`