import 'package:stock_manage/models/employee_model.dart';
import 'package:stock_manage/models/product_model.dart';

import '../models/category_model.dart';
import '../models/client_model.dart';
import '../models/order_model.dart';
import '../models/warehouse_model.dart';

class Global {
  static List<Employee> employees = [
    Employee(
      name: 'John Doe',
      role: 'Manager',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'john.doe@example.com',
      contactNumber: '123-456-7890',
      presentCount: 220,
      absentWithLeaveCount: 5,
      absentWithoutLeaveCount: 2,
    ),
    Employee(
      name: 'Jane Smith',
      role: 'Developer',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'jane.smith@example.com',
      contactNumber: '234-567-8901',
      presentCount: 215,
      absentWithLeaveCount: 3,
      absentWithoutLeaveCount: 1,
    ),
    Employee(
      name: 'Alice Johnson',
      role: 'Inventory Specialist',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'alice.johnson@example.com',
      contactNumber: '345-678-9012',
      presentCount: 218,
      absentWithLeaveCount: 4,
      absentWithoutLeaveCount: 0,
    ),
    Employee(
      name: 'Michael Brown',
      role: 'Warehouse Supervisor',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'michael.brown@example.com',
      contactNumber: '456-789-0123',
      presentCount: 210,
      absentWithLeaveCount: 6,
      absentWithoutLeaveCount: 2,
    ),
    Employee(
      name: 'Emily Davis',
      role: 'Sales Associate',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'emily.davis@example.com',
      contactNumber: '567-890-1234',
      presentCount: 230,
      absentWithLeaveCount: 2,
      absentWithoutLeaveCount: 1,
    ),
    Employee(
      name: 'David Wilson',
      role: 'Logistics Coordinator',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'david.wilson@example.com',
      contactNumber: '678-901-2345',
      presentCount: 225,
      absentWithLeaveCount: 3,
      absentWithoutLeaveCount: 3,
    ),
    Employee(
      name: 'Sophia Martinez',
      role: 'Quality Control Inspector',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'sophia.martinez@example.com',
      contactNumber: '789-012-3456',
      presentCount: 220,
      absentWithLeaveCount: 5,
      absentWithoutLeaveCount: 1,
    ),
    Employee(
      name: 'James Lee',
      role: 'Procurement Officer',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'james.lee@example.com',
      contactNumber: '890-123-4567',
      presentCount: 200,
      absentWithLeaveCount: 8,
      absentWithoutLeaveCount: 5,
    ),
    Employee(
      name: 'Olivia Garcia',
      role: 'Customer Service Representative',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'olivia.garcia@example.com',
      contactNumber: '901-234-5678',
      presentCount: 215,
      absentWithLeaveCount: 4,
      absentWithoutLeaveCount: 0,
    ),
    Employee(
      name: 'William Harris',
      role: 'Store Manager',
      imageUrl: 'https://via.placeholder.com/150',
      email: 'william.harris@example.com',
      contactNumber: '012-345-6789',
      presentCount: 220,
      absentWithLeaveCount: 5,
      absentWithoutLeaveCount: 2,
    ),
  ];

  static List<Warehouse> warehouses = [
    Warehouse(
      name: 'Warehouse 1',
      location: 'Location 1',
      id: 'W1',
      categories: [
        Category(
            id: 'C1', // Add id for category
            name: 'Category 1',
            imageUrl: 'https://via.placeholder.com/50',
            totalProducts: 100),
        Category(
            id: 'C2',
            name: 'Category 2',
            imageUrl: 'https://via.placeholder.com/50',
            totalProducts: 200),
      ],
    ),
    Warehouse(
      name: 'Warehouse 2',
      location: 'Location 2',
      id: 'W2',
      categories: [
        Category(
            id: 'C3',
            name: 'Category 3',
            imageUrl: 'https://via.placeholder.com/50',
            totalProducts: 150),
      ],
    ),
  ];

  static List<Product> products = [
    Product(id: 'P1', name: 'Product 1', stock: 50, categoryId: 'C1'),
    Product(id: 'P2', name: 'Product 2', stock: 30, categoryId: 'C1'),
    Product(id: 'P3', name: 'Product 3', stock: 20, categoryId: 'C2'),
    Product(id: 'P4', name: 'Product 4', stock: 10, categoryId: 'C3'),
  ];

  static List<Order> orders = [
    Order(orderID: 'DS50-790', status: 'Complete', date: 'April 20, 2023'),
    Order(orderID: 'ERO-COMP', status: 'Pending', date: 'April 18, 2023'),
    Order(orderID: '3DPI-981', status: 'Shipped', date: 'April 16, 2023'),
    Order(orderID: 'ERO-WG2', status: 'Cancelled', date: 'April 15, 2023'),
    // Add more initial orders here...
  ];

  static List<Client> clients = [
    Client(
      clientName: 'John Doe',
      email: 'john.doe@example.com',
      imageUrl: './assets/img/users/user_1.png',
      shopAddress: '1234 Elm St, Springfield, IL',
    ),
    Client(
      clientName: 'Jane Smith',
      email: 'jane.smith@example.com',
      imageUrl: './assets/img/users/user_1.png',
      shopAddress: '5678 Oak St, Springfield, IL',
    ),
    Client(
      clientName: 'Carlos Santana',
      email: 'carlos.santana@example.com',
      imageUrl: './assets/img/users/user_1.png',
      shopAddress: '9101 Maple St, Springfield, IL',
    ),
    Client(
      clientName: 'Linda Johnson',
      email: 'linda.johnson@example.com',
      imageUrl: './assets/img/users/user_1.png',
      shopAddress: '1121 Birch St, Springfield, IL',
    ),
    Client(
      clientName: 'Michael Brown',
      email: 'michael.brown@example.com',
      imageUrl: './assets/img/users/user_1.png',
      shopAddress: '1314 Cedar St, Springfield, IL',
    ),
  ];
}
