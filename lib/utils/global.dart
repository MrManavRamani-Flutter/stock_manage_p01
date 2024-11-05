import 'package:stock_manage/models/employee_model.dart';
import 'package:stock_manage/models/product_model.dart';
import 'package:stock_manage/models/purchase_model.dart';
import 'package:stock_manage/models/user_model.dart';

import '../models/category_model.dart';
import '../models/client_model.dart';
import '../models/order_model.dart';
import '../models/warehouse_model.dart';

class Global {
  static List<User> users = [
    User(
      uId: '1',
      username: 'demo',
      email: 'demo@gmail.com',
      password: '123',
      phone: '1234567890',
      role: 'owner',
      status: 1, // logged in
      createdAt: DateTime.now(),
    ),
    User(
      uId: '2',
      username: 'adminUser1',
      email: 'admin1@example.com',
      password: 'password123',
      phone: '0987654321',
      role: 'admin',
      status: 0, // not logged in
      createdAt: DateTime.now(),
    ),
    User(
      uId: '3',
      username: 'adminUser2',
      email: 'admin2@example.com',
      password: 'password123',
      phone: '1231231234',
      role: 'admin',
      status: 1, // logged in
      createdAt: DateTime.now(),
    ),
    User(
      uId: '4',
      username: 'guestUser1',
      email: 'guest1@example.com',
      password: 'password123',
      phone: '2345678901',
      role: 'guest',
      status: 0, // not logged in
      createdAt: DateTime.now(),
    ),
    User(
      uId: '5',
      username: 'guestUser2',
      email: 'guest2@example.com',
      password: 'password123',
      phone: '3456789012',
      role: 'guest',
      status: 1, // logged in
      createdAt: DateTime.now(),
    ),
    User(
      uId: '6',
      username: 'adminUser3',
      email: 'admin3@example.com',
      password: 'password123',
      phone: '4567890123',
      role: 'admin',
      status: 0, // not logged in
      createdAt: DateTime.now(),
    ),
    User(
      uId: '7',
      username: 'guestUser3',
      email: 'guest3@example.com',
      password: 'password123',
      phone: '5678901234',
      role: 'guest',
      status: 1, // logged in
      createdAt: DateTime.now(),
    ),
  ];

  static List<Employee> employees = [
    Employee(
      id: 'E1',
      // Added employee ID
      name: 'John Doe',
      role: 'Manager',
      email: 'john.doe@example.com',
      contactNumber: '123-456-7890',
      presentCount: 220,
      absentWithLeaveCount: 5,
      absentWithoutLeaveCount: 2,
    ),
    Employee(
      id: 'E2',
      // Added employee ID
      name: 'Jane Smith',
      role: 'Developer',
      email: 'jane.smith@example.com',
      contactNumber: '234-567-8901',
      presentCount: 215,
      absentWithLeaveCount: 3,
      absentWithoutLeaveCount: 1,
    ),
    Employee(
      id: 'E3',
      // Added employee ID
      name: 'Alice Johnson',
      role: 'Inventory Specialist',
      email: 'alice.johnson@example.com',
      contactNumber: '345-678-9012',
      presentCount: 218,
      absentWithLeaveCount: 4,
      absentWithoutLeaveCount: 0,
    ),
    Employee(
      id: 'E4',
      // Added employee ID
      name: 'Michael Brown',
      role: 'Warehouse Supervisor',
      email: 'michael.brown@example.com',
      contactNumber: '456-789-0123',
      presentCount: 210,
      absentWithLeaveCount: 6,
      absentWithoutLeaveCount: 2,
    ),
    Employee(
      id: 'E5',
      // Added employee ID
      name: 'Emily Davis',
      role: 'Sales Associate',
      email: 'emily.davis@example.com',
      contactNumber: '567-890-1234',
      presentCount: 230,
      absentWithLeaveCount: 2,
      absentWithoutLeaveCount: 1,
    ),
    Employee(
      id: 'E6',
      // Added employee ID
      name: 'David Wilson',
      role: 'Logistics Coordinator',
      email: 'david.wilson@example.com',
      contactNumber: '678-901-2345',
      presentCount: 225,
      absentWithLeaveCount: 3,
      absentWithoutLeaveCount: 3,
    ),
    Employee(
      id: 'E7',
      // Added employee ID
      name: 'Sophia Martinez',
      role: 'Quality Control Inspector',
      email: 'sophia.martinez@example.com',
      contactNumber: '789-012-3456',
      presentCount: 220,
      absentWithLeaveCount: 5,
      absentWithoutLeaveCount: 1,
    ),
    Employee(
      id: 'E8',
      // Added employee ID
      name: 'James Lee',
      role: 'Procurement Officer',
      email: 'james.lee@example.com',
      contactNumber: '890-123-4567',
      presentCount: 200,
      absentWithLeaveCount: 8,
      absentWithoutLeaveCount: 5,
    ),
    Employee(
      id: 'E9',
      // Added employee ID
      name: 'Olivia Garcia',
      role: 'Customer Service Representative',
      email: 'olivia.garcia@example.com',
      contactNumber: '901-234-5678',
      presentCount: 215,
      absentWithLeaveCount: 4,
      absentWithoutLeaveCount: 0,
    ),
    Employee(
      id: 'E10',
      // Added employee ID
      name: 'William Harris',
      role: 'Store Manager',
      email: 'william.harris@example.com',
      contactNumber: '012-345-6789',
      presentCount: 220,
      absentWithLeaveCount: 5,
      absentWithoutLeaveCount: 2,
    ),
  ];

  static List<Order> orders = [
    Order(orderID: 'DS50-790', status: 'Complete', date: 'April 20, 2023'),
    Order(orderID: 'ERO-COMP', status: 'Pending', date: 'April 18, 2023'),
    Order(orderID: '3DPI-981', status: 'Shipped', date: 'April 16, 2023'),
    Order(orderID: 'ERO-WG2', status: 'Cancelled', date: 'April 15, 2023'),
  ];

  static List<Warehouse> warehouses = [
    Warehouse(
      id: 'W1',
      name: 'Warehouse 1',
      location: 'Location 1',
      categories: [
        Category(
          id: 'C1',
          name: 'Category 1',
          totalProducts: 2, // Total products in this category
        ),
        Category(
          id: 'C2',
          name: 'Category 2',
          totalProducts: 1,
        ),
      ],
    ),
    Warehouse(
      id: 'W2',
      name: 'Warehouse 2',
      location: 'Location 2',
      categories: [
        Category(
          id: 'C3',
          name: 'Category 3',
          totalProducts: 1,
        ),
      ],
    ),
    Warehouse(
      id: 'W3',
      name: 'Warehouse 3',
      location: 'Location 3',
      categories: [
        Category(
          id: 'C4',
          name: 'Category 4',
          totalProducts: 1, // Initially empty
        ),
      ],
    ),
  ];

  static List<Client> clients = [
    Client(
        id: '1',
        clientName: 'John Doe',
        email: 'john.doe@example.com',
        contact: '123-456-7890',
        imageUrl: '',
        shopAddress: '1234 Elm St, Springfield, IL'),
    Client(
        id: '2',
        clientName: 'Jane Smith',
        email: 'jane.smith@example.com',
        contact: '987-654-3210',
        imageUrl: '',
        shopAddress: '5678 Oak St, Springfield, IL'),
    Client(
        id: '3',
        clientName: 'Alice Johnson',
        email: 'alice.johnson@example.com',
        contact: '555-555-5555',
        imageUrl: '',
        shopAddress: '2468 Pine St, Springfield, IL'),
    Client(
        id: '4',
        clientName: 'Michael Brown',
        email: 'michael.brown@example.com',
        contact: '444-444-4444',
        imageUrl: '',
        shopAddress: '1357 Maple St, Springfield, IL'),
  ];

  static List<Product> products = [
    Product(
      id: 'P1',
      name: 'Product 1',
      price: 1900.00,
      stock: 50,
      description: 'Description for Product 1',
      createdAt: DateTime.now(),
      wornLimitStock: 5,
      categoryId: 'C1',
      warehouseId: 'W1', // Associate with Warehouse 1
    ),
    Product(
      id: 'P2',
      name: 'Product 2',
      price: 2900.99,
      stock: 30,
      description: 'Description for Product 2',
      createdAt: DateTime.now(),
      wornLimitStock: 5,
      categoryId: 'C1',
      warehouseId: 'W1', // Associate with Warehouse 1
    ),
    Product(
      id: 'P3',
      name: 'Product 3',
      price: 3900.99,
      stock: 20,
      description: 'Description for Product 3',
      createdAt: DateTime.now(),
      wornLimitStock: 3,
      categoryId: 'C2',
      warehouseId: 'W1', // Associate with Warehouse 1
    ),
    Product(
      id: 'P4',
      name: 'Product 4',
      price: 10000.09,
      stock: 10,
      description: 'Description for Product 4',
      createdAt: DateTime.now(),
      wornLimitStock: 2,
      categoryId: 'C3',
      warehouseId: 'W2', // Associate with Warehouse 2
    ),
    Product(
      id: 'P5',
      name: 'Product 5',
      price: 1500.00,
      stock: 25,
      description: 'Description for Product 5',
      createdAt: DateTime.now(),
      wornLimitStock: 5,
      categoryId: 'C4',
      warehouseId: 'W3', // Associate with Warehouse 3
    ),
  ];

  static List<Purchase> purchases = [
    Purchase(
      purchaseId: 'PCH2020_04_01',
      clientId: '1',
      productId: 'P1',
      totalAmount: 5000.00,
      totalPayment: 3000.00,
      pendingPayment: 2000.00,
      stock: 12,
      createdAt: DateTime(2023, 4, 3),
    ),
    Purchase(
      purchaseId: 'PCH2020_04_06',
      clientId: '1',
      productId: 'P2',
      totalAmount: 6000.00,
      totalPayment: 4000.00,
      pendingPayment: 2000.00,
      stock: 14,
      createdAt: DateTime(2023, 6, 30),
    ),
    Purchase(
      purchaseId: 'PCH2020_04_08',
      clientId: '1',
      productId: 'P1',
      totalAmount: 4700.00,
      totalPayment: 4700.00,
      pendingPayment: 0.00,
      stock: 10,
      createdAt: DateTime(2024, 1, 27),
    ),

    Purchase(
      purchaseId: 'PCH2020_05_06',
      clientId: '1',
      productId: 'P2',
      totalAmount: 6000.00,
      totalPayment: 3000.00,
      pendingPayment: 3000.00,
      stock: 14,
      createdAt: DateTime(2024, 5, 30),
    ),
    Purchase(
      purchaseId: 'PCH2020_05_07',
      clientId: '3',
      productId: 'P3',
      totalAmount: 8000.00,
      totalPayment: 4000.00,
      pendingPayment: 4000.00,
      stock: 18,
      createdAt: DateTime(2024, 5, 28),
    ),
    Purchase(
      purchaseId: 'PCH2020_05_08',
      clientId: '1',
      productId: 'P1',
      totalAmount: 4700.00,
      totalPayment: 4700.00,
      pendingPayment: 0.00,
      stock: 10,
      createdAt: DateTime(2024, 5, 27),
    ),
    Purchase(
      purchaseId: 'PCH2020_05_09',
      clientId: '2',
      productId: 'P4',
      totalAmount: 9200.00,
      totalPayment: 9200.00,
      pendingPayment: 0.00,
      stock: 20,
      createdAt: DateTime(2024, 5, 24),
    ),
    Purchase(
      purchaseId: 'PCH2020_05_10',
      clientId: '3',
      productId: 'P5',
      totalAmount: 5000.00,
      totalPayment: 5000.00,
      pendingPayment: 0.00,
      stock: 7,
      createdAt: DateTime(2024, 5, 29),
    ),
    // June
    Purchase(
      purchaseId: 'PCH2020_06_01',
      clientId: '1',
      productId: 'P1',
      totalAmount: 6000.00,
      totalPayment: 2000.00,
      pendingPayment: 4000.00,
      stock: 12,
      createdAt: DateTime(2024, 6, 2),
    ),
    Purchase(
      purchaseId: 'PCH2020_06_03',
      clientId: '1',
      productId: 'P3',
      totalAmount: 6500.00,
      totalPayment: 6500.00,
      pendingPayment: 0.00,
      stock: 15,
      createdAt: DateTime(2024, 6, 15),
    ),
  ];
}
