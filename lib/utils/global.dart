import 'package:stock_manage/models/employee_model.dart';
import 'package:stock_manage/models/product_model.dart';
import 'package:stock_manage/models/purchase_model.dart';

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
      name: 'Warehouse 2',
      location: 'Location 2',
      id: 'W2',
      categories: [
        Category(
          id: 'C3',
          name: 'Category 3',
          totalProducts: 1,
        ),
      ],
    ),
  ];

  static List<Order> orders = [
    Order(orderID: 'DS50-790', status: 'Complete', date: 'April 20, 2023'),
    Order(orderID: 'ERO-COMP', status: 'Pending', date: 'April 18, 2023'),
    Order(orderID: '3DPI-981', status: 'Shipped', date: 'April 16, 2023'),
    Order(orderID: 'ERO-WG2', status: 'Cancelled', date: 'April 15, 2023'),
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
      // Associate with Category 1
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
      // Associate with Category 1
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
      // Associate with Category 2
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
      // Associate with Category 3
      warehouseId: 'W2', // Associate with Warehouse 2
    ),
  ];

  static List<Purchase> purchases = [
    Purchase(
      purchaseId: 'PCH1',
      clientId: '1',
      productId: 'P1',
      totalAmount: 10000.00,
      totalPayment: 7000.00,
      pendingPayment: 3000.00,
      stock: 50,
      createdAt: DateTime(2024, 1, 20), // Example date
    ),
    Purchase(
      purchaseId: 'PCH2',
      clientId: '1',
      productId: 'P2',
      totalAmount: 5000.00,
      totalPayment: 5000.00,
      pendingPayment: 0.00,
      stock: 20,
      createdAt: DateTime(2024, 3, 18),
    ),
    Purchase(
      purchaseId: 'PCH3',
      clientId: '2',
      productId: 'P3',
      totalAmount: 8000.00,
      totalPayment: 4000.00,
      pendingPayment: 4000.00,
      stock: 10,
      createdAt: DateTime(2024, 4, 16),
    ),
    Purchase(
      purchaseId: 'PCH4',
      clientId: '2',
      productId: 'P4',
      totalAmount: 12000.00,
      totalPayment: 6000.00,
      pendingPayment: 6000.00,
      stock: 5,
      createdAt: DateTime(2024, 4, 20),
    ),
  ];
}
