import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "input",
    "preview",
    "removeButton"
  ]
  
  connect() {
    console.log("image-preview controller connected!") // ←追加
  }
  
  preview() {
    const file = this.inputTarget.files[0]
    
    if (file) {
      const reader = new FileReader()
      
      reader.onload = (e) => {
        this.previewTarget.src = e.target.result
        this.previewTarget.classList.remove('hidden')

        this.removeButtonTarget.classList.remove('hidden')
      }
      
      reader.readAsDataURL(file)
    }
  }

  remove () {
    this.inputTarget.value = ''
    this.previewTarget.src = ""
    this.previewTarget.classList.add('hidden')

    this.removeButtonTarget.classList.add('hidden')    
  }
}