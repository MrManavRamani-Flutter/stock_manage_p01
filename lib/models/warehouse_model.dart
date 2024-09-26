import 'category_model.dart';

class Warehouse {
  final String name;
  final String location;
  final String id;
  final List<Category> categories;

  Warehouse({
    required this.name,
    required this.location,
    required this.id,
    required this.categories, // Initialize the categories
  });
}
