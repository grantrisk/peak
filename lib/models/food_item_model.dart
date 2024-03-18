enum FoodCategory {
  Dairy,
  Fruit,
  Vegetable,
  Protein,
  Grain,
  Fat,
  Sweet,
  Beverage,
  Other
}

class FoodItem {
  String id;
  String name;
  String owner;
  int calories;
  int carbs;
  int protein;
  int fat;
  int servingSize;
  String servingUnit;
  FoodCategory category;
  int? fiber;
  String? photoUrl;

  FoodItem({
    required this.id,
    required this.name,
    required this.owner,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.servingSize,
    required this.servingUnit,
    required this.category,
    this.fiber,
    this.photoUrl,
  });
}
