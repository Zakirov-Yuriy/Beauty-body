/// Переводит тип меала на русский язык
String translateMealType(String type) {
  const Map<String, String> translations = {
    'breakfast': 'Завтрак',
    'lunch': 'Обед',
    'snack': 'Перекус',
    'dinner': 'Ужин',
  };
  return translations[type] ?? type;
}
