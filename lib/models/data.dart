class MealItem {
  final String type;
  final String name;
  final String portion;
  final String extra;
  final String emoji;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final List<Ingredient> ingredients;
  final List<String> steps;

  const MealItem({
    required this.type,
    required this.name,
    required this.portion,
    this.extra = '',
    required this.emoji,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.ingredients = const [],
    this.steps = const [],
  });
}

class Ingredient {
  final String name;
  final String amount;
  const Ingredient(this.name, this.amount);
}

class DayPlan {
  final String dayName;
  final String dayShort;
  final List<MealItem> meals;
  final bool isCompleted;
  final bool isToday;

  const DayPlan({
    required this.dayName,
    required this.dayShort,
    required this.meals,
    this.isCompleted = false,
    this.isToday = false,
  });
}

class ShopItem {
  final String name;
  final String quantity;
  final String category;
  bool isChecked;

  ShopItem({
    required this.name,
    required this.quantity,
    required this.category,
    this.isChecked = false,
  });
}

class NotificationItem {
  final String title;
  final String subtitle;
  final String emoji;
  final String time;
  final String bgColorHex;

  const NotificationItem({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.time,
    this.bgColorHex = 'E8F5D0',
  });
}

class ChatMessage {
  final String initials;
  final String text;
  final String time;
  final bool isMe;
  final String avatarColor;

  const ChatMessage({
    required this.initials,
    required this.text,
    required this.time,
    this.isMe = false,
    this.avatarColor = 'C8E6A0',
  });
}

// Sample data
class AppData {
  static final List<MealItem> mondayMeals = [
    MealItem(
      type: 'Завтрак',
      name: 'Творожный бейгл',
      portion: '150/180/200 г',
      emoji: '🥯',
      calories: 280,
      protein: 18,
      carbs: 34,
      fat: 8,
      ingredients: [
        Ingredient('Бейгл цельнозерновой', '1 шт'),
        Ingredient('Творог 5%', '80 г'),
        Ingredient('Слабосолёная сёмга', '30 г'),
        Ingredient('Зелёный лук', 'по вкусу'),
      ],
      steps: [
        'Разрезать бейгл пополам и слегка поджарить на сухой сковороде.',
        'Смешать творог со специями до однородной массы.',
        'Нанести творожную пасту на обе половины бейгла.',
        'Сверху выложить ломтики сёмги и украсить зелёным луком.',
      ],
    ),
    MealItem(
      type: 'Обед',
      name: 'Плов из булгура',
      portion: '180/220/250 г',
      extra: 'Хлеб цельнозерновой 30 г\nВосточный салат 120 г',
      emoji: '🍲',
      calories: 320,
      protein: 18,
      carbs: 45,
      fat: 8,
      ingredients: [
        Ingredient('Булгур', '100 г'),
        Ingredient('Куриная грудка', '80 г'),
        Ingredient('Морковь', '40 г'),
        Ingredient('Лук репчатый', '40 г'),
        Ingredient('Томатная паста', '1 ч.л.'),
        Ingredient('Специи (зира, куркума)', 'по вкусу'),
      ],
      steps: [
        'Обжарить лук и морковь до золотистости на небольшом количестве масла.',
        'Добавить нарезанную кубиками куриную грудку, тушить 10 минут.',
        'Промытый булгур всыпать к мясу, добавить томатную пасту и специи.',
        'Залить водой в соотношении 1:2, накрыть крышкой и варить 15 минут.',
        'Дать настояться 5 минут под крышкой перед подачей.',
      ],
    ),
    MealItem(
      type: 'Перекус',
      name: 'Творожный мусс',
      portion: '150 г',
      emoji: '🍓',
      calories: 150,
      protein: 14,
      carbs: 16,
      fat: 4,
      ingredients: [
        Ingredient('Творог 5%', '100 г'),
        Ingredient('Клубника', '50 г'),
        Ingredient('Банан', '½ шт'),
        Ingredient('Стевия', 'по вкусу'),
      ],
      steps: [
        'Творог взбить блендером до воздушной консистенции.',
        'Добавить стевию по вкусу, перемешать.',
        'Выложить в стакан слоями с нарезанными фруктами.',
        'Украсить ягодами и подавать охлаждённым.',
      ],
    ),
    MealItem(
      type: 'Ужин',
      name: 'Нутовый салат',
      portion: '160/180/200 г',
      extra: 'Добавка: 1 варёное яйцо',
      emoji: '🥗',
      calories: 245,
      protein: 15,
      carbs: 28,
      fat: 9,
      ingredients: [
        Ingredient('Нут консервированный', '150 г'),
        Ingredient('Огурец', '80 г'),
        Ingredient('Помидор', '80 г'),
        Ingredient('Болгарский перец', '60 г'),
        Ingredient('Кинза / петрушка', 'пучок'),
        Ingredient('Лимонный сок', '1 ст.л.'),
        Ingredient('Оливковое масло', '1 ч.л.'),
      ],
      steps: [
        'Нут промыть и обсушить.',
        'Все овощи нарезать средними кубиками.',
        'Смешать все ингредиенты в миске.',
        'Заправить лимонным соком и маслом, посолить по вкусу.',
        'Украсить зеленью и подавать сразу.',
      ],
    ),
  ];

  static final List<List<MealItem>> weekPlan = [
    mondayMeals, // Пн
    mondayMeals, // Вт (placeholder)
    mondayMeals, // Ср
    mondayMeals, // Чт
    mondayMeals, // Пт
    mondayMeals, // Сб
    mondayMeals, // Вс
  ];

  static final List<ShopItem> shopItems = [
    ShopItem(name: 'Куриная грудка', quantity: '400 г', category: 'БЕЛКИ', isChecked: true),
    ShopItem(name: 'Творог 5%', quantity: '500 г', category: 'БЕЛКИ', isChecked: true),
    ShopItem(name: 'Яйца', quantity: '10 шт', category: 'БЕЛКИ'),
    ShopItem(name: 'Слабосолёная сёмга', quantity: '150 г', category: 'БЕЛКИ'),
    ShopItem(name: 'Булгур', quantity: '300 г', category: 'КРУПЫ'),
    ShopItem(name: 'Нут консервированный', quantity: '2 банки', category: 'КРУПЫ'),
    ShopItem(name: 'Хлеб цельнозерновой', quantity: '1 буханка', category: 'КРУПЫ'),
    ShopItem(name: 'Помидоры', quantity: '500 г', category: 'ОВОЩИ'),
    ShopItem(name: 'Болгарский перец', quantity: '3 шт', category: 'ОВОЩИ'),
    ShopItem(name: 'Огурцы', quantity: '4 шт', category: 'ОВОЩИ'),
    ShopItem(name: 'Клубника', quantity: '200 г', category: 'ФРУКТЫ'),
    ShopItem(name: 'Бананы', quantity: '3 шт', category: 'ФРУКТЫ'),
  ];

  static final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Время завтрака!',
      subtitle: 'Творожный бейгл ждёт тебя',
      emoji: '🌅',
      time: '5 мин назад',
      bgColorHex: 'FFF3E0',
    ),
    NotificationItem(
      title: 'День 8 завершён! 🎉',
      subtitle: 'Ты молодец! -0.3 кг за сегодня',
      emoji: '🎉',
      time: '2 часа назад',
      bgColorHex: 'E8F5D0',
    ),
    NotificationItem(
      title: 'Не забудь про воду',
      subtitle: 'Норма: 1.5–2 литра в день',
      emoji: '💧',
      time: '4 часа назад',
      bgColorHex: 'E8F0FF',
    ),
    NotificationItem(
      title: 'Новый рекорд!',
      subtitle: 'Вес 68.5 кг — лучший результат',
      emoji: '🏆',
      time: 'Вчера',
      bgColorHex: 'FCE4EC',
    ),
    NotificationItem(
      title: 'Готов план на завтра',
      subtitle: 'Меню на среду уже доступно',
      emoji: '📋',
      time: 'Вчера',
      bgColorHex: 'E8F5D0',
    ),
    NotificationItem(
      title: 'Список покупок обновлён',
      subtitle: '7 новых продуктов на неделю 2',
      emoji: '🛒',
      time: 'Вчера',
      bgColorHex: 'FFF3E0',
    ),
  ];

  static final List<ChatMessage> chatMessages = [
    ChatMessage(
      initials: 'МА',
      text: 'Девочки, минус 4 кг за 7 дней! 🎉',
      time: '09:14',
      avatarColor: 'C8E6A0',
    ),
    ChatMessage(
      initials: 'ОЛ',
      text: 'Как вам плов из булгура? Мне очень понравился!',
      time: '09:31',
      avatarColor: 'F0C8C8',
    ),
    ChatMessage(
      initials: 'Я',
      text: 'Тоже готовила! Добавила чеснок 🧄 Получилось супер',
      time: '09:45',
      isMe: true,
    ),
    ChatMessage(
      initials: 'ТА',
      text: 'Кто-нибудь делал аджику из рецепта куратора?',
      time: '10:02',
      avatarColor: 'C8D8F0',
    ),
    ChatMessage(
      initials: 'МА',
      text: 'Да! Очень вкусно, но я взяла меньше острого перца 😅',
      time: '10:15',
      avatarColor: 'C8E6A0',
    ),
  ];
}
