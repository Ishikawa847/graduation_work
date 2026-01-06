import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["input", "results"]
  connect() {
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)

    const query = this.inputTarget.value

    if (query.length === 0) {
      this.hideResults()
      return
    }

    this.timeout = setTimeout(() =>{
      fetch(`/recipes/autocomplete?q[name_or_description_cont]=${query}`)
      .then(response => response.json())
      .then(data =>{
        this.displayResults(data)
      })
    }, 300)
  }

  displayResults(results) {
    if (results.length === 0) {
      this.hideResults()
      return
    }

    this.resultsTarget.innerHTML = results.map(result => {
      return`
        <li data-action="click->autocomplete#select" data-id="${result.id}">
          ${result.name}
        </li>
        `
    }).join('')

    this.showResults()
  }

  select(event) {
    const id = event.target.dataset.id
    window.location.href = `/recipes/${id}`
  }

  showResults() {
    this.resultsTarget.style.display = 'block'
  }

  hideResults() {
    this.resultsTarget.style.display = 'none'
  }
}
