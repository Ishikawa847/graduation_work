document.addEventListener('DOMContentLoaded', function() {
  const addButton = document.getElementById('add-ingredient');
  const container = document.getElementById('ingredients-container');
  let ingredientIndex = document.querySelectorAll('.ingredient-item').length;

  addButton.addEventListener('click', function() {
    const newIngredientHTML = `
      <div class="ingredient-item mb-4 p-4 border rounded-lg bg-gray-50">
        <div class="grid grid-cols-1 md:grid-cols-6 gap-3">
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-1">食材名</label>
            <input type="text" 
                   name="recipe[recipe_ingredients_attributes][${ingredientIndex}][ingredient_name]" 
                   class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" 
                   placeholder="例：鶏むね肉">
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">分量(g)</label>
            <input type="number" 
                   name="recipe[recipe_ingredients_attributes][${ingredientIndex}][quantity]" 
                   class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" 
                   placeholder="100" min="1">
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">タンパク質</label>
            <input type="number" step="0.1"
                   name="recipe[recipe_ingredients_attributes][${ingredientIndex}][protein_per_100g]" 
                   class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" 
                   placeholder="23.3">
            <span class="text-xs text-gray-500">g/100g</span>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">脂質</label>
            <input type="number" step="0.1"
                   name="recipe[recipe_ingredients_attributes][${ingredientIndex}][fat_per_100g]" 
                   class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" 
                   placeholder="1.5">
            <span class="text-xs text-gray-500">g/100g</span>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">炭水化物</label>
            <input type="number" step="0.1"
                   name="recipe[recipe_ingredients_attributes][${ingredientIndex}][carbohydrate_per_100g]" 
                   class="block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500" 
                   placeholder="0">
            <span class="text-xs text-gray-500">g/100g</span>
          </div>
          
          <div class="flex items-end">
            <button type="button" class="remove-ingredient bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-3 rounded text-sm w-full">
              削除
            </button>
          </div>
        </div>
      </div>
    `;
    
    container.insertAdjacentHTML('beforeend', newIngredientHTML);
    ingredientIndex++;
  });

  // ⭐ 削除ボタンのイベントリスナー（動的に追加された要素にも対応）
  container.addEventListener('click', function(event) {
    if (event.target.classList.contains('remove-ingredient')) {
      const ingredientItem = event.target.closest('.ingredient-item');
      ingredientItem.remove();
    }
  });
});