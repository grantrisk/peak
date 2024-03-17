import 'package:peak/models/food_item_model.dart';

enum MealType { Breakfast, Lunch, Dinner, Snack, Other }

class Meal {
  String id;
  String name;
  String owner;
  DateTime dateTime;
  MealType type;
  List<FoodItem> foodItems;
  int calories;
  int carbs;
  int protein;
  int fat;

  Meal({
    required this.id,
    required this.name,
    required this.owner,
    required this.dateTime,
    required this.type,
    required this.foodItems,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
  });
}
