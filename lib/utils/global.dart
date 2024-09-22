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
      userName: 'John Doe',
      email: 'john.doe@example.com',
      imageUrl: './assets/img/users/user_1.png',
      shopAddress: '1234 Elm St, Springfield, IL',
      totalPurchases: 10,
      returnStock: 2,
      contactInfo: '555-1234',
      productsPurchased: [
        Product(name: 'Widget A', quantity: 5),
        Product(name: 'Widget B', quantity: 3),
      ],
    ),
    User(
      userName: 'Jane Smith',
      email: 'jane.smith@example.com',
      imageUrl: './assets/img/users/user_1.png',
      shopAddress: '5678 Oak St, Springfield, IL',
      totalPurchases: 15,
      returnStock: 0,
      contactInfo: '555-5678',
      productsPurchased: [
        Product(name: 'Gadget X', quantity: 7),
      ],
    ),
    User(
      userName: 'Carlos Santana',
      email: 'carlos.santana@example.com',
      imageUrl: './assets/img/users/user_1.png',
      shopAddress: '9101 Maple St, Springfield, IL',
      totalPurchases: 8,
      returnStock: 1,
      contactInfo: '555-9101',
      productsPurchased: [
        Product(name: 'Component Z', quantity: 4),
      ],
    ),
    User(
      userName: 'Linda Johnson',
      email: 'linda.johnson@example.com',
      imageUrl: './assets/img/users/user_1.png',
      shopAddress: '1121 Birch St, Springfield, IL',
      totalPurchases: 20,
      returnStock: 3,
      contactInfo: '555-1121',
      productsPurchased: [
        Product(name: 'Peripheral Q', quantity: 6),
      ],
    ),
    User(
      userName: 'Michael Brown',
      email: 'michael.brown@example.com',
      imageUrl: './assets/img/users/user_1.png',
      shopAddress: '1314 Cedar St, Springfield, IL',
      totalPurchases: 12,
      returnStock: 0,
      contactInfo: '555-1314',
      productsPurchased: [
        Product(name: 'Accessory Y', quantity: 2),
      ],
    ),
  ];
}
