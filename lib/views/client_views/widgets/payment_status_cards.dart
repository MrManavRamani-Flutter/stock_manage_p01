import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';

class PaymentStatusCards extends StatelessWidget {
  final double totalPaid;
  final double totalPending;

  const PaymentStatusCards({
    super.key,
    required this.totalPaid,
    required this.totalPending,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatusCard("Total Paid", totalPaid, Colors.green),
        _buildStatusCard("Total Pending", totalPending, Colors.red),
      ],
    );
  }

  Widget _buildStatusCard(String title, double amount, Color cardColor) {
    return Card(
      elevation: 4.0,
      color: cardColor.withOpacity(0.1), // Background color with slight opacity
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // Ensure the card height fits its content
          children: [
            _buildCardTitle(title),
            const SizedBox(height: 8),
            _buildCardAmount(amount),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor, // Consistent text color
      ),
    );
  }

  Widget _buildCardAmount(double amount) {
    return Text(
      "Rs. ${amount.toStringAsFixed(2)}",
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.textColor, // Consistent text color
      ),
    );
  }
}
