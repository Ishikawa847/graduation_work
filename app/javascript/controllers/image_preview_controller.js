import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "input",
    "preview",
    "removeButton",
    "uploadIcon",
    "uploadArea",
    "uploadHint"
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

        this.hideUploadElements()
      }
      
      reader.readAsDataURL(file)
    }
  }

  remove () {
    this.inputTarget.value = ''
    this.previewTarget.src = ""
    this.previewTarget.classList.add('hidden')

    this.removeButtonTarget.classList.add('hidden') 
    
    this.showUploadElements()
  }

  hideUploadElements() {
    if (this.hasUploadIconTarget) {
      this.uploadIconTarget.classList.add('hidden')
    }

    if (this.hasUploadAreaTarget) {
      this.uploadAreaTarget.classList.add('hidden')
    }
    
    if (this.hasUploadHintTarget) {
      this.uploadHintTarget.classList.add('hidden')
    }

  }

  showUploadElements() {
    if (this.hasUploadIconTarget) {
      this.uploadIconTarget.classList.remove('hidden')
    } 

    if (this.hasUploadAreaTarget) {
      this.uploadAreaTarget.classList.remove('hidden')
    } 

    if (this.hasUploadHintTarget) {
      this.uploadHintTarget.classList.remove('hidden')
    } 
  }
}