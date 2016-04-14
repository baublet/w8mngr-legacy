w8mngr.foodEntries.templates.foodEntry = `
  <div class="row entry" transition="fl-fade">
    <div class="col long">
      <input type="text" @keyup.enter="saveEntry(index)" v-model="description">
    </div>
    <div class="col short" title="Calories">
      <input type="text" @keyup.enter="saveEntry(index)" v-model="calories">
    </div>
    <div class="col short" title="Fat">
      <input type="text" @keyup.enter="saveEntry(index)" v-model="fat">
    </div>
    <div class="col short" title="Carbs">
      <input type="text" @keyup.enter="saveEntry(index)" v-model="carbs">
    </div>
    <div class="col short" title="Protein">
      <input type="text" @keyup.enter="saveEntry(index)" v-model="protein">
    </div>
    <div class="col meta">
      <a href="#" class="btn delete-btn" title="Delete Entry"
        @click.stop.prevent="removeEntry(index)"
        v-if="id">
        <i class="fa fa-times"></i>
        <span class="screen-reader-text">Delete Entry</span>
      </a>
    </div>
  </div>
`