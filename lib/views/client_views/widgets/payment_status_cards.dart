import 'package:flutter/material.dart';

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
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCardTitle(title, cardColor),
            const SizedBox(height: 8),
            _buildCardAmount(amount, cardColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTitle(String title, Color cardColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: cardColor.withOpacity(0.6), // Consistent text color
      ),
    );
  }

  Widget _buildCardAmount(double amount, Color cardColor) {
    return Text(
      "Rs. ${amount.toStringAsFixed(2)}",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: cardColor, // Consistent text color
      ),
    );
  }
}
