import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["overlay", "submit"]
  
    connect() {
    this.element.addEventListener("submit", this.showLoading.bind(this))
  }

  showLoading(event) {
    const fileInput = this.element.querySelector('input[type="file"]')
    
    if (fileInput && fileInput.files.length > 0) {
      this.overlayTarget.classList.remove("hidden")
      
      if (this.hasSubmitTarget) {
        this.submitTarget.disabled = true
      }
    }
  }
}