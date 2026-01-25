import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "input",
    "searchButton",
    "loading",
    "error",
    "success"
  ]

  connect() {
    console.log("Ingredient Search Controller connected")
  }

  async search(event) {
    event.preventDefault()
    
    const foodName = this.inputTarget.value.trim()
    
    if (!foodName) {
      this.showError('食材名を入力してください')
      return
    }

    try {
      this.startLoading()
      this.hideMessages()
      
      const response = await fetch('/recipes/search_nutrition', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({ food_name: foodName })
      })

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.error || '検索に失敗しました')
      }

      // 成功メッセージを表示
      this.showSuccess(data.message, data.ingredient)
      
      // 入力フィールドをクリア
      this.inputTarget.value = ''
      
      // ページをリロードして、食材リストを更新
      setTimeout(() => {
        location.reload()
      }, 2000)
      
    } catch (error) {
      console.error('Search error:', error)
      this.showError(error.message)
    } finally {
      this.stopLoading()
    }
  }

  startLoading() {
    this.searchButtonTarget.disabled = true
    this.loadingTarget.classList.remove('hidden')
  }

  stopLoading() {
    this.searchButtonTarget.disabled = false
    this.loadingTarget.classList.add('hidden')
  }

  hideMessages() {
    this.errorTarget.classList.add('hidden')
    this.successTarget.classList.add('hidden')
  }

  showError(message) {
    this.errorTarget.textContent = message
    this.errorTarget.classList.remove('hidden')
  }

  showSuccess(message, ingredient) {
    const successMessage = `
      ${message}
      <div class="mt-2 text-sm">
        <strong>${ingredient.name}</strong>
        <div class="grid grid-cols-3 gap-2 mt-1">
          <div>P: ${ingredient.protein}g</div>
          <div>F: ${ingredient.fat}g</div>
          <div>C: ${ingredient.carb}g</div>
        </div>
      </div>
      <p class="mt-2 text-xs">2秒後にページを更新します...</p>
    `
    this.successTarget.innerHTML = successMessage
    this.successTarget.classList.remove('hidden')
  }
}