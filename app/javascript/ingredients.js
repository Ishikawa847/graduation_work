document.addEventListener('DOMContentLoaded', function() {
  const addButton = document.getElementById('add-ingredient');
  const container = document.getElementById('ingredients-container');
  let ingredientIndex = document.querySelectorAll('.ingredient-item').length;

  addButton.addEventListener('click', function() {
    const newIngredientHTML = `
      <div class="ingredient-item mb-4 p-4 border border-gray-700 rounded-lg bg-gray-800">
        <div class="grid grid-cols-1 md:grid-cols-6 gap-4">
          <!-- 材料名入力（ingredient_attributes内） -->
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-200 mb-1">食材名</label>
            <input type="text" 
                   name="recipe[recipe_ingredients_attributes][${ingredientIndex}][ingredient_attributes][name]" 
                   class="w-full rounded-md bg-gray-900 border-gray-700 text-gray-100 placeholder-gray-500 focus:border-blue-500 focus:ring-blue-500" 
                   placeholder="例：鶏むね肉">
          </div>
          
          <!-- 分量入力（recipe_ingredientの属性） -->
          <div>
            <label class="block text-sm font-medium text-gray-200 mb-1">分量</label>
            <input type="text" 
                   name="recipe[recipe_ingredients_attributes][${ingredientIndex}][quantity]" 
                   class="w-full rounded-md bg-gray-900 border-gray-700 text-gray-100 placeholder-gray-500 focus:border-blue-500 focus:ring-blue-500" 
                   placeholder="例: 200g">
          </div>
          
          <!-- 栄養価情報（ingredient_attributes内） -->
          <div>
            <label class="block text-sm font-medium text-gray-200 mb-1">タンパク質</label>
            <input type="number" step="0.1"
                   name="recipe[recipe_ingredients_attributes][${ingredientIndex}][ingredient_attributes][protein]" 
                   class="w-full rounded-md bg-gray-900 border-gray-700 text-gray-100 focus:border-blue-500 focus:ring-blue-500" 
                   placeholder="23.3">
            <span class="text-xs text-gray-400">g/100g</span>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-200 mb-1">脂質</label>
            <input type="number" step="0.1"
                   name="recipe[recipe_ingredients_attributes][${ingredientIndex}][ingredient_attributes][fat]" 
                   class="w-full rounded-md bg-gray-900 border-gray-700 text-gray-100 focus:border-blue-500 focus:ring-blue-500" 
                   placeholder="1.9">
            <span class="text-xs text-gray-400">g/100g</span>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-200 mb-1">炭水化物</label>
            <input type="number" step="0.1"
                   name="recipe[recipe_ingredients_attributes][${ingredientIndex}][ingredient_attributes][carb]" 
                   class="w-full rounded-md bg-gray-900 border-gray-700 text-gray-100 focus:border-blue-500 focus:ring-blue-500" 
                   placeholder="0">
            <span class="text-xs text-gray-400">g/100g</span>
          </div>
          
          <div class="flex items-end">
            <!-- 削除用のhiddenフィールド -->
            <input type="hidden" 
                   name="recipe[recipe_ingredients_attributes][${ingredientIndex}][_destroy]" 
                   value="false" 
                   class="destroy-field">
            <button type="button" 
                    class="remove-ingredient bg-red-600 hover:bg-red-700 text-white font-bold py-1 px-3 rounded text-sm w-full">
              削除
            </button>
          </div>
        </div>
      </div>
    `;
    
    container.insertAdjacentHTML('beforeend', newIngredientHTML);
    ingredientIndex++;
  });

  // 削除ボタンのイベントリスナー
  container.addEventListener('click', function(event) {
    if (event.target.classList.contains('remove-ingredient')) {
      const ingredientItem = event.target.closest('.ingredient-item');
      ingredientItem.remove();
    }
  });
});