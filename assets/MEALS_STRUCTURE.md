# 📁 Структура Картинок Блюд (Assets Structure)

## Полная Иерархия папок

```
assets/
  meals/
    ├── stage_1/                    # Этап 1
    │   ├── week_1/                 # Неделя 1
    │   │   ├── day_1/              # Понедельник
    │   │   │   ├── breakfast_1.png  # Завтрак 1
    │   │   │   ├── lunch_1.png      # Обед 1
    │   │   │   ├── snack_1.png      # Перекус 1
    │   │   │   └── dinner_1.png     # Ужин 1
    │   │   ├── day_2/              # Вторник
    │   │   │   ├── breakfast_1.png
    │   │   │   └── ...
    │   │   ├── day_3/              # Среда
    │   │   ├── day_4/              # Четверг
    │   │   ├── day_5/              # Пятница
    │   │   ├── day_6/              # Суббота
    │   │   └── day_7/              # Воскресенье
    │   ├── week_2/                 # Неделя 2
    │   │   ├── day_1/
    │   │   ├── day_2/
    │   │   └── ... (day_3...day_7)
    │   └── week_3/                 # Неделя 3
    │       ├── day_1/
    │       └── ... (day_2...day_7)
    ├── stage_2/                    # Этап 2
    │   ├── week_1/
    │   │   ├── day_1/
    │   │   └── ... (day_2...day_7)
    │   └── ...
    └── stage_3/                    # Этап 3
        ├── week_1/
        │   ├── day_1/
        │   └── ... (day_2...day_7)
        └── ...
```

## Система Названий Файлов

### Формат: `{type}_{mealNumber}.png`

**Типы блюд (type):**
- `breakfast_` - Завтрак (завтраки в день)
- `lunch_` - Обед (обеды в день)
- `snack_` - Перекус (перекусы в день)
- `dinner_` - Ужин (ужины в день)

**Примеры:**
```
day_1/breakfast_1.png    # 1-й завтрак в понедельник
day_1/lunch_2.png        # 2-й обед в понедельник
day_3/dinner_1.png       # 1-й ужин в среду
day_5/snack_1.png        # 1-й перекус в пятницу
```

## Полные Пути в Коде

### Примеры использования в sample_meals.dart:

```dart
// Этап 1, Неделя 1, День 1, Завтрак
imageAssetPath: 'assets/meals/stage_1/week_1/day_1/breakfast_1.png',

// Этап 1, Неделя 1, День 2, Обед
imageAssetPath: 'assets/meals/stage_1/week_1/day_2/lunch_1.png',

// Этап 1, Неделя 2, День 3, Ужин
imageAssetPath: 'assets/meals/stage_1/week_2/day_3/dinner_1.png',

// Этап 2, Неделя 1, День 1, Завтрак
imageAssetPath: 'assets/meals/stage_2/week_1/day_1/breakfast_1.png',

// Этап 3, Неделя 1, День 5, Перекус
imageAssetPath: 'assets/meals/stage_3/week_1/day_5/snack_1.png',
```

## Требования к Картинкам

- **Формат:** PNG (с поддержкой прозрачности)
- **Размер:** 300x300 px (минимум) или 600x600 px (рекомендуется)
- **Аспект:** Квадратный (1:1)
- **Фон:** Прозрачный или чистый цвет, совместимый с темой

## Как Добавить Новое Изображение

1. Пощади картинку в соответствующую папку:
   ```
   assets/meals/stage_{N}/week_{N}/
   ```

2. Обнови имя файла по формату `{type}_{number}.png`

3. Обнови путь в коде:
   ```dart
   imageAssetPath: 'assets/meals/stage_1/week_1/breakfast_1.png',
   ```

4. Убедись, что путь указан в `pubspec.yaml` (если картинка новая):
   ```yaml
   flutter:
     assets:
       - assets/
       - assets/meals/
   ```

## Текущие Блюда Stage 1, Week 1, Day 1 (Понедельник)

**Завтраки:**
- `breakfast_1.png` (day_1) - Творожная пища (cottage_cheese_meal)
  - Путь: `assets/meals/stage_1/week_1/day_1/breakfast_1.png`
  - ID: meal_1
- `breakfast_1.png` (day_2) - Яичница по-маррокански (shakshuka_meal)
  - Путь: `assets/meals/stage_1/week_1/day_2/breakfast_1.png`
  - ID: meal_7
  - Размеры: 160г (маленькая), 200г (средняя), 220г (большая)

**Обеды:**
- `lunch_1.png` - Паста с соусом Болоньезе (pasta_bolognese_meal)
  - Путь: `assets/meals/stage_1/week_1/day_1/lunch_1.png`
  - ID: meal_10
  - Размеры: 180г (маленькая), 250г (средняя), 350г (большая)
- `lunch_2.png` - Летний салат (summer_salad_meal)
  - Путь: `assets/meals/stage_1/week_1/day_1/lunch_2.png`
  - ID: meal_15
  - Размер: 120г (стандартная)

**Перекусы:**
- `snack_1.png` (day_1) - Фруктовый салат (fruit_salad_meal)
  - Путь: `assets/meals/stage_1/week_1/day_1/snack_1.png`
  - ID: meal_4
  - Размер: 150г (стандартная)
- `snack_1.png` (day_2) - ШП - слоёный десерт (layered_dessert_meal)
  - Путь: `assets/meals/stage_1/week_1/day_2/snack_1.png`
  - ID: meal_8
  - Размер: 120г (стандартная)

**Ужины:**
- `dinner_1.png` - Тефтели по-домашнему с булгуром (meatballs_dinner_meal)
  - Путь: `assets/meals/stage_1/week_1/day_1/dinner_1.png`
  - ID: meal_25
  - Размеры: 300г (маленькая), 300г (средняя), 320г (большая)
- `dinner_2.png` (day_2) - Фаршированные кабачки (stuffed_zucchini_meal)
  - Путь: `assets/meals/stage_1/week_1/day_2/dinner_2.png`
  - ID: meal_9
  - Размеры: 150г (маленькая), 200г (средняя), 250г (большая)

## День 3 (Среда) - Структура Меню

**Завтраки:**
- `breakfast_1.png` (day_3) - ПП рулетики с начинкой (pp_rolls_meal)
  - Путь: `assets/meals/stage_1/week_1/day_3/breakfast_1.png`
  - ID: meal_14
  - Размеры: 130г (маленькая), 150г (средняя), 180г (большая)

**Перекусы:**
- `snack_1.png` (day_3) - Чипсы из лаваша (lavash_chips_meal)
  - Путь: `assets/meals/stage_1/week_1/day_3/snack_1.png`
  - ID: meal_10
  - Размер: 50г (стандартная)
- `snack_2.png` (day_3) - ПП аджика (adjika_meal)
  - Путь: `assets/meals/stage_1/week_1/day_3/snack_2.png`
  - ID: meal_11
  - Размер: 50г (стандартная)
- `snack_3.png` (day_3) - ПП вареная сгущенка (condensed_milk_meal)
  - Путь: `assets/meals/stage_1/week_1/day_3/snack_3.png`
  - ID: meal_12
  - Размер: 30г (стандартная)
- `snack_4.png` (day_3) - ПП конфитюр (confiture_meal)
  - Путь: `assets/meals/stage_1/week_1/day_3/snack_4.png`
  - ID: meal_13
  - Размер: 50г (стандартная)

**Ужины:**
- `dinner_1.png` (day_3) - Куриная грудка (chicken_breast_meal)
  - Путь: `assets/meals/stage_1/week_1/day_3/dinner_1.png`
  - ID: meal_15
  - Размеры: 80г (маленькая), 100г (средняя), 120г (большая)
- `dinner_2.png` (day_3) - Запечённый овощной микс (baked_veggies_meal)
  - Путь: `assets/meals/stage_1/week_1/day_3/dinner_2.png`
  - ID: meal_16
  - Размер: 120г (стандартная)

---

**Обновлено:** 08.04.2026  
**Версия:** 3.0
