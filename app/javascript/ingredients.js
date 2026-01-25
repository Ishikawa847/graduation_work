document.addEventListener('turbo:load', () => {
  const container = document.getElementById('ingredients-container');
  if (!container) return;

  const ingredientsData = window.ingredientsData || [];

  container.addEventListener('change', (e) => {
    if (e.target.classList.contains('ingredient-select')) {
      const selectedOption = e.target.options[e.target.selectedIndex];
      const ingredientItem = e.target.closest('.ingredient-item');
      const existingQuantityInput = ingredientItem.querySelector('.existing-quantity');
      const nutritionInfo = ingredientItem.querySelector('.nutrition-info');
      
      if (e.target.value) {
        
        existingQuantityInput.disabled = false;
        existingQuantityInput.focus();
        
        let protein = selectedOption.dataset.protein;
        let fat = selectedOption.dataset.fat;
        let carb = selectedOption.dataset.carb;
                
        if ((!protein || protein == '0') && ingredientsData.length > 0) {
          const selectedId = e.target.value;
          const ingredient = ingredientsData.find(ing => ing.id == selectedId);
          if (ingredient) {
            protein = ingredient.protein || 0;
            fat = ingredient.fat || 0;
            carb = ingredient.carb || 0;
          }
        }
        
        nutritionInfo.querySelector('.nutrition-display-protein').textContent = protein || 0;
        nutritionInfo.querySelector('.nutrition-display-fat').textContent = fat || 0;
        nutritionInfo.querySelector('.nutrition-display-carb').textContent = carb || 0;
        nutritionInfo.style.display = 'block';
        
      } else {
        existingQuantityInput.disabled = true;
        existingQuantityInput.value = '';
        nutritionInfo.style.display = 'none';
      }
    }
  });


  container.addEventListener('click', (e) => {
    if (e.target.classList.contains('remove-ingredient')) {
      const ingredientItem = e.target.closest('.ingredient-item');
      const items = container.querySelectorAll('.ingredient-item');
      
      if (items.length > 1) {
        ingredientItem.remove();
      } else {
        alert('最低1つの食材が必要です');
      }
    }
  });


  const addIngredientButton = document.getElementById('add-ingredient');
  if (addIngredientButton) {
    addIngredientButton.addEventListener('click', () => {
      const items = container.querySelectorAll('.ingredient-item');
      const lastItem = items[items.length - 1];
      const newItem = lastItem.cloneNode(true);
      
      const inputs = newItem.querySelectorAll('input, select, textarea');
      inputs.forEach(input => {
        if (input.type === 'checkbox' || input.type === 'radio') {
          input.checked = false;
        } else {
          input.value = '';
        }
        
        if (input.classList.contains('existing-quantity')) {
          input.disabled = true;
        }
      });
      
      const nutritionInfo = newItem.querySelector('.nutrition-info');
      if (nutritionInfo) {
        nutritionInfo.style.display = 'none';
      }
      
      const select = newItem.querySelector('.ingredient-select');
      if (select) {
        select.selectedIndex = 0;
      }
      
      container.appendChild(newItem);
    });
  }
});