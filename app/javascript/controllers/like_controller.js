import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "count", "icon"] // icon targetを追加
  static values = {
    recipeId: String,
    liked: Boolean
  }

  connect() {
    this.updateButton()
  }

  async toggle(event) {
    event.preventDefault()
    console.log("Toggle clicked!")
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

// updateButton メソッド内
updateButton() {
  if (!this.hasIconTarget) return

  const path = this.iconTarget.querySelector('path')
  const fullHeart = "M11.645 20.91l-.007-.003-.022-.012a15.247 15.247 0 01-.383-.218 25.18 25.18 0 01-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.5 3c1.557 0 3.046.727 4 2.015C12.454 3.727 13.943 3 15.5 3 18.286 3 20.75 5.322 20.75 8.25c0 3.924-2.438 7.11-4.73 9.282a25.115 25.115 0 01-4.245 3.17 15.267 15.267 0 01-.382.218l-.022.012-.007.004-.002.001z"
  const outlineHeart = "M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12z"

  if (this.likedValue) {
    this.iconTarget.classList.add('fill-white', 'text-white')
    this.iconTarget.classList.remove('fill-none', 'text-gray-500')
    this.iconTarget.setAttribute('stroke', 'none') // 塗りつぶし時は枠線を消す
    path.setAttribute('d', fullHeart)
  } else {
    this.iconTarget.classList.remove('fill-white', 'text-white')
    this.iconTarget.classList.add('fill-none', 'text-gray-500')
    this.iconTarget.setAttribute('stroke', 'currentColor') // 未いいね時は枠線を表示
    path.setAttribute('d', outlineHeart)
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