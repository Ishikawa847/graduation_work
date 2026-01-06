import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {
  static targets = ["inputs", "results"]
  connect() {
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)

    const query = this.inputTarget.value

    if (query.length === 0) {
      this.hideResults()
      renturn
    }

    this.timeout = setTimeout(() =>{
      fetch('/recipes/autocomplete?q[title_or_body_cont]=${query}')
      .then(response => response.json)
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
      return
        <li data-aciton="click->autocomplete#select" data-id="${result.id}">
          ${result.title}
        </li>
    }).join('')

    this.showResults()
  }

  select(event) {
    const id = event.target.dataset.id
    window.location.href = '/recipes/${id}'
  }

  showResults() {
    this.resultsTarget.style.display = 'block'
  }

  hideResults() {
    this.resultsTarget.style.display = 'none'
  }
}
