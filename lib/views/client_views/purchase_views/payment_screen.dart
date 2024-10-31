import 'package:flutter/material.dart';
import 'package:stock_manage/models/client_model.dart';
import 'package:stock_manage/models/purchase_model.dart';
import 'package:stock_manage/utils/global.dart';

class PaymentScreen extends StatefulWidget {
  final Client client;
  final List<Purchase> purchases;
  final double totalPending;
  final Function onPaymentConfirmed;

  const PaymentScreen({
    super.key,
    required this.client,
    required this.purchases,
    required this.totalPending,
    required this.onPaymentConfirmed,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Map to hold payment amounts for each purchase
  final Map<Purchase, double> _paymentAmounts = {};
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    _initializePaymentAmounts();
  }

  // Initialize payment amounts to 0.0 for each purchase
  void _initializePaymentAmounts() {
    for (var purchase in widget.purchases) {
      _paymentAmounts[purchase] = 0.0;
    }
  }

  // Check if all payment amounts are valid
  bool _isPaymentValid() {
    for (var purchase in widget.purchases) {
      final paymentAmount = _paymentAmounts[purchase] ?? 0.0;
      // If any payment amount exceeds the pending amount, return false
      if (paymentAmount > purchase.pendingPayment) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientInfo(), // Display client information
            _buildTotalPending(), // Display total pending payment
            _buildPurchaseList(), // Display the list of purchases
            const SizedBox(height: 20),
            // Show the confirm payment button if all amounts are valid
            (isVisible) ? _buildConfirmPaymentButton() : Container(),
          ],
        ),
      ),
    );
  }

  // Build widget to display client information
  Widget _buildClientInfo() {
    return Text(
      "Client: ${widget.client.clientName}",
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  // Build widget to display total pending payment
  Widget _buildTotalPending() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        "Total Pending Payment: Rs. ${widget.totalPending.toStringAsFixed(2)}",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Build widget to display the list of purchases
  Widget _buildPurchaseList() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.purchases.length,
        itemBuilder: (context, index) {
          final purchase = widget.purchases[index];
          final product =
              Global.products.firstWhere((p) => p.id == purchase.productId);
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Pending: Rs. ${purchase.pendingPayment.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Amount to Pay:'),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: "Amount",
                            isDense: true,
                          ),
                          onChanged: (value) {
                            setState(() {
                              isVisible = true;

                              final amount = double.tryParse(value) ?? 0.0;
                              // If the entered amount exceeds the pending amount, show an error and reset
                              if (amount > purchase.pendingPayment) {
                                isVisible = false;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Amount cannot exceed pending amount of Rs. ${purchase.pendingPayment.toStringAsFixed(2)}',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                // _paymentAmounts[purchase] = purchase
                                //     .pendingPayment; // Set to max allowed
                              } else {
                                _paymentAmounts[purchase] =
                                    amount; // Update payment amount
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Build the confirm payment button
  Widget _buildConfirmPaymentButton() {
    // Check if the button should be enabled
    final isValid = _isPaymentValid();
    return Center(
      child: ElevatedButton(
        onPressed: isValid ? _confirmPayment : null, // Enable only if valid
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Confirm Payment',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Confirm payment logic
  void _confirmPayment() {
    for (var purchase in widget.purchases) {
      final paymentAmount = _paymentAmounts[purchase] ?? 0.0;
      // Ensure no payment exceeds the pending amount
      if (paymentAmount > purchase.pendingPayment) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: Payment for ${purchase.productId} exceeds pending amount.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return; // Stop if there's an error
      }
    }

    // Deduct the payment amounts from the pending payments
    for (var purchase in widget.purchases) {
      final paymentAmount = _paymentAmounts[purchase] ?? 0.0;
      if (paymentAmount > 0) {
        purchase.pendingPayment -= paymentAmount; // Deduct payment
        purchase.totalPayment += paymentAmount; // Update total payment
      }
    }
    widget.onPaymentConfirmed(); // Notify the client details to refresh
    Navigator.pop(context); // Close the payment screen
  }
}
