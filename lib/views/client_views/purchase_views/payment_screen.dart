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
  final Map<Purchase, double> _paymentAmounts = {};

  @override
  void initState() {
    super.initState();
    _initializePaymentAmounts();
  }

  void _initializePaymentAmounts() {
    for (var purchase in widget.purchases) {
      _paymentAmounts[purchase] = 0.0;
    }
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
            _buildClientInfo(),
            _buildTotalPending(),
            _buildPurchaseList(),
            _buildConfirmPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInfo() {
    return Text(
      "Client: ${widget.client.clientName}",
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTotalPending() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        "Total Pending Payment: Rs. ${widget.totalPending.toStringAsFixed(2)}",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "Pending: Rs. ${purchase.pendingPayment.toStringAsFixed(2)}"),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Amount to Pay:'),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: "Amount"),
                          onChanged: (value) {
                            setState(() {
                              _paymentAmounts[purchase] =
                                  double.tryParse(value) ?? 0.0;
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

  Widget _buildConfirmPaymentButton() {
    return ElevatedButton(
      onPressed: _confirmPayment,
      child: const Text('Confirm Payment'),
    );
  }

  double _calculateTotalPayment() {
    return _paymentAmounts.values.fold(0.0, (sum, value) => sum + value);
  }

  void _confirmPayment() {
    final totalPayment = _calculateTotalPayment();

    for (var purchase in widget.purchases) {
      final paymentAmount = _paymentAmounts[purchase] ?? 0.0;
      if (paymentAmount > 0) {
        purchase.pendingPayment -= paymentAmount; // Deduct the payment
        purchase.totalPayment += paymentAmount; // Update total payment
      }
    }

    widget.onPaymentConfirmed(); // Notify client details to refresh
    Navigator.pop(context);
  }
}
