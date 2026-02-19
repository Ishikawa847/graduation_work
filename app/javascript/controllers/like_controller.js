import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "count"]
  static values = {
    recipeId: String,
    liked: Boolean
  }

  connect() {
    this.updateButton()
  }

  async toggle(event) {
    event.preventDefault()
    
    this.buttonTarget.disabled = true
    
    try {
      const url = `/recipes/${this.recipeIdValue}/like`
      const method = this.likedValue ? 'DELETE' : 'POST'
      
      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': this.csrfToken()
        }
      })
      
      if (response.ok) {
        const data = await response.json()
        this.likedValue = data.liked
        this.updateCount(data.likes_count)
        this.updateButton()
      }
    } catch (error) {
      console.error('Error:', error)
    } finally {
      this.buttonTarget.disabled = false
    }
  }

  updateButton() {
    const icon = this.buttonTarget.querySelector('i')
    
    if (this.likedValue) {
      this.buttonTarget.classList.remove('btn-outline-danger')
      this.buttonTarget.classList.add('btn-danger')
      icon.classList.remove('bi-heart')
      icon.classList.add('bi-heart-fill')
    } else {
      this.buttonTarget.classList.remove('btn-danger')
      this.buttonTarget.classList.add('btn-outline-danger')
      icon.classList.remove('bi-heart-fill')
      icon.classList.add('bi-heart')
    }
  }

  updateCount(count) {
    if (this.hasCountTarget) {
      this.countTarget.textContent = count
    }
  }

  csrfToken() {
    return document.querySelector('meta[name="csrf-token"]').content
  }
}