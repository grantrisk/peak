import 'package:peak/models/food_item_model.dart';
import 'package:peak/models/meal_model.dart';

class DailyIntake {
  String id;
  String owner;
  DateTime date;
  List<Meal> meals;
  List<FoodItem> foodItems;
  int calories;
  int carbs;
  int protein;
  int fat;
  int goalCalories;
  int goalCarbs;
  int goalProtein;
  int goalFat;

  DailyIntake({
    required this.id,
    required this.owner,
    required this.date,
    required this.meals,
    required this.foodItems,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.goalCalories,
    required this.goalCarbs,
    required this.goalProtein,
    required this.goalFat,
  });
}
