import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ClientDetails extends StatelessWidget {
  const ClientDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Client Details',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: AppColors.primaryColor),
            label: const Text(
              'Edit',
              style: TextStyle(color: AppColors.primaryColor),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromWidth(100),
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client Information Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        child: FlutterLogo(size: 40),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Name: client_1",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("Shop: shop_name_1"),
                          SizedBox(height: 8),
                          Text("Email: client1@gmail.com"),
                          SizedBox(height: 8),
                          Text("Contact: 1234567890"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.grey, thickness: 1),
              const SizedBox(height: 20),

              // Paid and Pending Status Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatusCard("Paid", "\$100,000", Colors.green),
                  _buildStatusCard("Pending", "\$3,510,000", Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              _buildTotalCard("Total", "\$3,610,000", Colors.blue),

              const SizedBox(height: 20),
              const Text(
                "Purchase Details:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Product-wise Purchase Details List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildProductCard(
                    productImage: 'assets/img/users/user_1.png',
                    productName: 'Product ${index + 1}',
                    totalAmount: '\$10,000',
                    totalPayment: '\$7,500',
                    pendingPayment: '\$2,500',
                    stock: '100 units', // Stock available
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Paid and Pending Status Cards
  Widget _buildStatusCard(String label, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Widget for Total Card
  Widget _buildTotalCard(String label, String amount, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Product Card (Product Details: Image, Name, Amounts, Stock)
  Widget _buildProductCard({
    required String productImage,
    required String productName,
    required String totalAmount,
    required String totalPayment,
    required String pendingPayment,
    required String stock,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Product Image
            Image.asset(
              productImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 20),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("Total Amount: $totalAmount"),
                  Text("Total Payment: $totalPayment"),
                  Text("Pending Payment: $pendingPayment"),
                  Text("Stock: $stock"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
