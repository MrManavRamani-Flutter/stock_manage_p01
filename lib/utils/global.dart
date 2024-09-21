import '../models/category_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../models/warehouse_model.dart';

class Global {
  static List<Warehouse> warehouses = [
    Warehouse(name: 'Warehouse 1', location: 'Dallas, TX'),
    Warehouse(name: 'Warehouse 2', location: 'Chicago, IL'),
  ];
  static List<Category> categories = [
    Category(name: 'Central Components', productCount: 5),
    Category(name: 'Peripherals', productCount: 3),
    Category(name: 'Connectors', productCount: 2),
    Category(name: 'Body', productCount: 4),
    // Add more categories here if needed
  ];
  static List<Order> orders = [
    Order(orderID: 'DS50-790', status: 'Complete', date: 'April 20, 2023'),
    Order(orderID: 'ERO-COMP', status: 'Pending', date: 'April 18, 2023'),
    Order(orderID: '3DPI-981', status: 'Shipped', date: 'April 16, 2023'),
    Order(orderID: 'ERO-WG2', status: 'Cancelled', date: 'April 15, 2023'),
    // Add more initial orders here...
  ];
  static List<User> users = [
    User(
      userName: 'Alma Mambery',
      email: 'alma.mambery@example.com',
      imageUrl: './assets/img/users/user_1.png',
    ),
    User(
      userName: 'Elisa Moraes',
      email: 'elisa.moraes@example.com',
      imageUrl: './assets/img/users/user_1.png',
    ),
    User(
      userName: 'Hugo Saavedra',
      email: 'hugo.saavedra@example.com',
      imageUrl: './assets/img/users/user_1.png',
    ),
    User(
      userName: 'Ivan Coripe',
      email: 'ivan.coripe@example.com',
      imageUrl: './assets/img/users/user_1.png',
    ),
    User(
      userName: 'Fatima Delgadio',
      email: 'fatima.delgadio@example.com',
      imageUrl: './assets/img/users/user_1.png',
    ),
  ];
}
