// app/javascript/controllers/ingredient_controller.js
document.addEventListener('turbo:load', () => {
  const container = document.getElementById('ingredients-container');
  if (!container) return;

  const ingredientsData = window.ingredientsData || [];
  
  console.log('📊 ingredientsData:', ingredientsData); // デバッグ用


  container.addEventListener('change', (e) => {
    if (e.target.classList.contains('ingredient-select')) {
      const selectedOption = e.target.options[e.target.selectedIndex];
      const ingredientItem = e.target.closest('.ingredient-item');
      const existingQuantityInput = ingredientItem.querySelector('.existing-quantity');
      const newIngredientForm = ingredientItem.querySelector('.new-ingredient-form');
      const newQuantityInput = ingredientItem.querySelector('.new-quantity');
      const newIngredientInputs = newIngredientForm.querySelectorAll('input, textarea, select');
      const nutritionInfo = ingredientItem.querySelector('.nutrition-info');
      
      if (e.target.value) {
        console.log('✅ 既存食材が選択されました:', e.target.value);
        
        existingQuantityInput.disabled = false;
        existingQuantityInput.focus();
        
        newIngredientInputs.forEach(input => {
          input.value = '';
          input.disabled = true;
        });
        newQuantityInput.value = '';
        newQuantityInput.disabled = true;
        
        newIngredientForm.style.display = 'none';
        const expandIcon = ingredientItem.querySelector('.expand-icon');
        if (expandIcon) {
          expandIcon.style.transform = 'rotate(0deg)';
        }
        
        let protein = selectedOption.dataset.protein;
        let fat = selectedOption.dataset.fat;
        let carb = selectedOption.dataset.carb;
        
        console.log('📊 data属性から取得:', { protein, fat, carb });
        
        if ((!protein || protein == '0') && ingredientsData.length > 0) {
          const selectedId = e.target.value;
          const ingredient = ingredientsData.find(ing => ing.id == selectedId);
          if (ingredient) {
            console.log('📊 ingredientsDataから取得:', ingredient);
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
    if (e.target.closest('.toggle-new-ingredient')) {
      const button = e.target.closest('.toggle-new-ingredient');
      const ingredientItem = button.closest('.ingredient-item');
      const newIngredientForm = ingredientItem.querySelector('.new-ingredient-form');
      const expandIcon = button.querySelector('.expand-icon');
      const existingSelect = ingredientItem.querySelector('.ingredient-select');
      const existingQuantityInput = ingredientItem.querySelector('.existing-quantity');
      const nutritionInfo = ingredientItem.querySelector('.nutrition-info');
      
      if (newIngredientForm.style.display === 'none' || !newIngredientForm.style.display) {
        console.log('📝 新規食材フォームを開きます');
        newIngredientForm.style.display = 'block';
        expandIcon.style.transform = 'rotate(90deg)';
        
        const newIngredientInputs = newIngredientForm.querySelectorAll(
          '.new-ingredient-name, .new-ingredient-protein, .new-ingredient-fat, .new-ingredient-carb'
        );
        newIngredientInputs.forEach(input => {
          input.disabled = false;
        });
        
        existingSelect.value = '';
        existingQuantityInput.value = '';
        existingQuantityInput.disabled = true;
        
        nutritionInfo.style.display = 'none';
      } else {
        console.log('📝 新規食材フォームを閉じます');
        newIngredientForm.style.display = 'none';
        expandIcon.style.transform = 'rotate(0deg)';
        
        const newIngredientInputs = newIngredientForm.querySelectorAll('input, textarea, select');
        const newQuantityInput = ingredientItem.querySelector('.new-quantity');
        newIngredientInputs.forEach(input => {
          input.value = '';
          input.disabled = true;
        });
        newQuantityInput.value = '';
        newQuantityInput.disabled = true;
      }
    }
  });


  container.addEventListener('input', (e) => {
    if (e.target.classList.contains('new-ingredient-name') ||
        e.target.classList.contains('new-ingredient-protein') ||
        e.target.classList.contains('new-ingredient-fat') ||
        e.target.classList.contains('new-ingredient-carb')) {
      
      const ingredientItem = e.target.closest('.ingredient-item');
      const nameInput = ingredientItem.querySelector('.new-ingredient-name');
      const proteinInput = ingredientItem.querySelector('.new-ingredient-protein');
      const fatInput = ingredientItem.querySelector('.new-ingredient-fat');
      const carbInput = ingredientItem.querySelector('.new-ingredient-carb');
      const newQuantityInput = ingredientItem.querySelector('.new-quantity');
      
      if (nameInput.value && proteinInput.value && fatInput.value && carbInput.value) {
        console.log('✅ 新規食材の情報が揃いました');
        newQuantityInput.disabled = false;
      } else {
        newQuantityInput.disabled = true;
        newQuantityInput.value = '';
      }
    }
  });


  container.addEventListener('click', (e) => {
    if (e.target.classList.contains('remove-ingredient')) {
      const ingredientItem = e.target.closest('.ingredient-item');
      const items = container.querySelectorAll('.ingredient-item');
      
      if (items.length > 1) {
        ingredientItem.remove();
        console.log('🗑️ 食材を削除しました');
      } else {
        alert('最低1つの食材が必要です');
      }
    }
  });


  const addButton = document.getElementById('add-ingredient');
  if (addButton) {
    addButton.addEventListener('click', () => {
      const items = container.querySelectorAll('.ingredient-item');
      const lastItem = items[items.length - 1];
      const newItem = lastItem.cloneNode(true);
      
      const inputs = newItem.querySelectorAll('input, select, textarea');
      inputs.forEach(input => {
        input.value = '';
        if (input.classList.contains('existing-quantity') || 
            input.classList.contains('new-quantity') ||
            input.classList.contains('new-ingredient-name') ||
            input.classList.contains('new-ingredient-protein') ||
            input.classList.contains('new-ingredient-fat') ||
            input.classList.contains('new-ingredient-carb')) {
          input.disabled = true;
        } else if (input.classList.contains('ingredient-select')) {
          input.disabled = false;
        }
      });
      
      const newIngredientForm = newItem.querySelector('.new-ingredient-form');
      newIngredientForm.style.display = 'none';
      const expandIcon = newItem.querySelector('.expand-icon');
      expandIcon.style.transform = 'rotate(0deg)';
      
      const nutritionInfo = newItem.querySelector('.nutrition-info');
      nutritionInfo.style.display = 'none';
      
      const timestamp = new Date().getTime();
      inputs.forEach(input => {
        if (input.name) {
          input.name = input.name.replace(/\[\d+\]/, `[${timestamp}]`);
        }
      });
      
      container.appendChild(newItem);
      console.log('➕ 新しい食材フォームを追加しました');
    });
  }
});