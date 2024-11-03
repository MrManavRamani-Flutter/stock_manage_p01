import 'package:flutter/material.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/models/client_model.dart';
import 'package:stock_manage/models/purchase_model.dart';
import 'package:stock_manage/models/purchase_summary.dart';
import 'package:stock_manage/utils/global.dart';
import 'package:stock_manage/views/client_views/client_update.dart';
import 'package:stock_manage/views/client_views/generate_bill/generate_bill_view.dart';
import 'package:stock_manage/views/client_views/purchase_views/payment_screen.dart';
import 'package:stock_manage/views/client_views/purchase_views/purchase_details_list.dart';
import 'package:stock_manage/views/client_views/widgets/client_info_card.dart';
import 'package:stock_manage/views/client_views/widgets/payment_status_cards.dart';
import 'package:stock_manage/views/client_views/widgets/total_card.dart';

class ClientDetails extends StatefulWidget {
  final Client client;

  const ClientDetails({super.key, required this.client});

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  late List<Purchase> clientPurchases;
  late PurchaseSummary summary;

  @override
  void initState() {
    super.initState();
    _fetchClientPurchases();
  }

  void _fetchClientPurchases() {
    setState(() {
      clientPurchases = Global.purchases
          .where((purchase) => purchase.clientId == widget.client.id)
          .toList();
      summary = _calculatePurchasesSummary(clientPurchases);
    });
  }

  void _updateClientDetails(Client updatedClient) {
    setState(() {
      Global.clients[Global.clients
              .indexWhere((client) => client.id == updatedClient.id)] =
          updatedClient;
      _fetchClientPurchases();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(color: AppColors.white),
        iconTheme: const IconThemeData(color: AppColors.white),
        title: const Text(
          'Client Details',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchClientPurchases,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditClient,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  void _navigateToEditClient() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditClientView(
          client: widget.client,
          onClientUpdated: _updateClientDetails,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClientInfoCard(client: widget.client),
          const Divider(color: AppColors.gray, thickness: 1),
          PaymentStatusCards(
            totalPaid: summary.totalPaid,
            totalPending: summary.totalPending,
          ),
          TotalCard(
            label: "Total",
            amount: summary.totalAmount.toStringAsFixed(2),
            color: AppColors.accentColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPayPendingButton(),
              _buildGenerateBillButton(),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Purchase Details",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor),
          ),
          PurchaseDetailsList(purchases: clientPurchases),
        ],
      ),
    );
  }

  Widget _buildPayPendingButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _navigateToPaymentScreen,
        child: const Text("Pay Pending Amount"),
      ),
    );
  }

  void _navigateToPaymentScreen() {
    final pendingPurchases = clientPurchases
        .where((purchase) => purchase.pendingPayment > 0)
        .toList();

    if (pendingPurchases.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No pending amounts available.')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          client: widget.client,
          purchases: pendingPurchases,
          totalPending: pendingPurchases.fold(
              0.0, (sum, purchase) => sum + purchase.pendingPayment),
          onPaymentConfirmed: () {
            setState(() {
              _fetchClientPurchases();
            });
          },
        ),
      ),
    ).then((_) {
      _fetchClientPurchases();
    });
  }

  Widget _buildGenerateBillButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _generateBill,
        child: const Text("Generate Bill"),
      ),
    );
  }

  void _generateBill() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerateBillView(client: widget.client),
      ),
    );
  }

  PurchaseSummary _calculatePurchasesSummary(List<Purchase> purchases) {
    double totalAmount =
        purchases.fold(0.0, (sum, purchase) => sum + purchase.totalAmount);
    double totalPaid =
        purchases.fold(0.0, (sum, purchase) => sum + purchase.totalPayment);
    double totalPending = totalAmount - totalPaid;

    return PurchaseSummary(
      totalPurchases: purchases.length,
      totalAmount: totalAmount,
      totalPaid: totalPaid,
      totalPending: totalPending,
    );
  }
}
