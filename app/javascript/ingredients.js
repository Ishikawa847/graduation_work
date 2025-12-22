document.addEventListener('turbo:load', () => {
  const container = document.getElementById('ingredients-container');
  if (!container) return;

  // 既存食材データを取得(グローバル変数から)
  const ingredientsData = window.ingredientsData || [];

  // ===================================
  // 1. 既存食材選択時の処理
  // ===================================
  container.addEventListener('change', (e) => {
    if (e.target.classList.contains('ingredient-select')) {
      const ingredientItem = e.target.closest('.ingredient-item');
      const existingQuantityInput = ingredientItem.querySelector('.existing-quantity');
      const newIngredientForm = ingredientItem.querySelector('.new-ingredient-form');
      const newQuantityInput = ingredientItem.querySelector('.new-quantity');
      const newIngredientInputs = newIngredientForm.querySelectorAll('input, textarea, select');
      const nutritionInfo = ingredientItem.querySelector('.nutrition-info');
      
      if (e.target.value) {
        // 既存食材が選択された場合
        console.log('既存食材が選択されました:', e.target.value);
        
        // 既存食材用の分量入力を有効化
        existingQuantityInput.disabled = false;
        existingQuantityInput.focus();
        
        // 新規食材フォームを無効化・クリア
        newIngredientInputs.forEach(input => {
          input.value = '';
          input.disabled = true;
        });
        newQuantityInput.value = '';
        newQuantityInput.disabled = true;
        
        // 新規食材フォームを閉じる
        newIngredientForm.style.display = 'none';
        const expandIcon = ingredientItem.querySelector('.expand-icon');
        if (expandIcon) {
          expandIcon.style.transform = 'rotate(0deg)';
        }
        
        // 栄養価情報を表示(データがあれば)
        const selectedId = e.target.value;
        const ingredient = ingredientsData.find(ing => ing.id == selectedId);
        if (ingredient) {
          nutritionInfo.querySelector('.nutrition-display-protein').textContent = ingredient.protein;
          nutritionInfo.querySelector('.nutrition-display-fat').textContent = ingredient.fat;
          nutritionInfo.querySelector('.nutrition-display-carb').textContent = ingredient.carb;
          nutritionInfo.style.display = 'block';
        }
      } else {
        // 選択解除時
        existingQuantityInput.disabled = true;
        existingQuantityInput.value = '';
        nutritionInfo.style.display = 'none';
      }
    }
  });

  // ===================================
  // 2. 新規食材フォームの開閉
  // ===================================
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
        // フォームを開く
        console.log('新規食材フォームを開きます');
        newIngredientForm.style.display = 'block';
        expandIcon.style.transform = 'rotate(90deg)';
        
        // 新規食材フォームの入力欄を有効化
        const newIngredientInputs = newIngredientForm.querySelectorAll(
          '.new-ingredient-name, .new-ingredient-protein, .new-ingredient-fat, .new-ingredient-carb'
        );
        newIngredientInputs.forEach(input => {
          input.disabled = false;
        });
        
        // 既存食材の選択をクリア・無効化
        existingSelect.value = '';
        existingQuantityInput.value = '';
        existingQuantityInput.disabled = true;
        
        // 栄養価表示を非表示
        nutritionInfo.style.display = 'none';
      } else {
        // フォームを閉じる
        console.log('新規食材フォームを閉じます');
        newIngredientForm.style.display = 'none';
        expandIcon.style.transform = 'rotate(0deg)';
        
        // 新規食材フォームの入力欄を無効化・クリア
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

  // ===================================
  // 3. 新規食材の入力監視
  // ===================================
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
      
      // すべての必須フィールドが入力されているかチェック
      if (nameInput.value && proteinInput.value && fatInput.value && carbInput.value) {
        console.log('新規食材の情報が揃いました');
        newQuantityInput.disabled = false;
      } else {
        newQuantityInput.disabled = true;
        newQuantityInput.value = '';
      }
    }
  });

  // ===================================
  // 4. 食材削除ボタン
  // ===================================
  container.addEventListener('click', (e) => {
    if (e.target.classList.contains('remove-ingredient')) {
      const ingredientItem = e.target.closest('.ingredient-item');
      const items = container.querySelectorAll('.ingredient-item');
      
      if (items.length > 1) {
        ingredientItem.remove();
        console.log('食材を削除しました');
      } else {
        alert('最低1つの食材が必要です');
      }
    }
  });
  // ===================================
  // 5. 食材追加ボタン
  // ===================================
  const addButton = document.getElementById('add-ingredient');
  if (addButton) {
    addButton.addEventListener('click', () => {
      const items = container.querySelectorAll('.ingredient-item');
      const lastItem = items[items.length - 1];
      const newItem = lastItem.cloneNode(true);
      
      // 新しいフォームの初期化
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
      
      // 新規食材フォームを閉じた状態にする
      const newIngredientForm = newItem.querySelector('.new-ingredient-form');
      newIngredientForm.style.display = 'none';
      const expandIcon = newItem.querySelector('.expand-icon');
      expandIcon.style.transform = 'rotate(0deg)';
      
      // 栄養価表示を非表示
      const nutritionInfo = newItem.querySelector('.nutrition-info');
      nutritionInfo.style.display = 'none';
      
      // name属性の更新(重要!)
      const timestamp = new Date().getTime();
      inputs.forEach(input => {
        if (input.name) {
          input.name = input.name.replace(/\[\d+\]/, `[${timestamp}]`);
        }
      });
      
      container.appendChild(newItem);
      console.log('新しい食材フォームを追加しました');
    });
  }
});