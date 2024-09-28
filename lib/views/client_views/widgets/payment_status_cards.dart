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
        _buildStatusCard(
            "Paid", "\$${totalPaid.toStringAsFixed(2)}", Colors.green),
        _buildStatusCard(
            "Pending", "\$${totalPending.toStringAsFixed(2)}", Colors.red),
      ],
    );
  }

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
                fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontSize: 16)),
        ],
      ),
    );
  }
}
