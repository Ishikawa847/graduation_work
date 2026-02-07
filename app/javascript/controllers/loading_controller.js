import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "submit"]

  connect() {
    this.element.addEventListener("submit", this.showLoading.bind(this))
    console.log("loading controller connected")
  }

  showLoading(event) {
    this.overlayTarget.classList.remove("hidden")
    
    if (this.hasSubmitTarget) {
      this.submitTarget.disabled = true
    }
  }
}