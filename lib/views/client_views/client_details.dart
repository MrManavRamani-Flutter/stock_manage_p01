import 'package:flutter/material.dart';
import 'package:stock_manage/models/purchase_summary.dart';
import 'package:stock_manage/views/client_views/client_update.dart';
import 'package:stock_manage/views/client_views/purchase_wiews/purchase_details_list.dart';
import 'package:stock_manage/views/client_views/purchase_wiews/purchase_products.dart';
import 'package:stock_manage/views/client_views/widgets/client_info_card.dart';
import 'package:stock_manage/views/client_views/widgets/payment_status_cards.dart';
import 'package:stock_manage/views/client_views/widgets/total_card.dart';

import '../../constants/app_colors.dart';
import '../../models/client_model.dart';
import '../../models/purchase_model.dart';
import '../../utils/global.dart';

class ClientDetails extends StatefulWidget {
  final Client client;

  const ClientDetails({super.key, required this.client});

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  late List<Purchase> clientPurchases;
  late PurchaseSummary summary;
  late Client currentClient;

  @override
  void initState() {
    super.initState();
    currentClient = widget.client;
    _fetchClientPurchases();
  }

  void _fetchClientPurchases() {
    clientPurchases = Global.purchases
        .where((purchase) => purchase.clientId == currentClient.id)
        .toList();
    summary = _calculatePurchasesSummary(clientPurchases);
  }

  void _updateClientDetails(Client updatedClient) {
    setState(() {
      currentClient = updatedClient;

      final index =
          Global.clients.indexWhere((client) => client.id == currentClient.id);
      if (index != -1) {
        Global.clients[index] = updatedClient;
      }

      _fetchClientPurchases(); // Re-fetch purchases for updated client
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Details'),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: const TextStyle(
            color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 20),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditClientView(
                    client: currentClient,
                    onClientUpdated: _updateClientDetails,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.backgroundColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClientInfoCard(client: currentClient),
              const SizedBox(height: 20),
              const Divider(color: AppColors.gray, thickness: 1),
              const SizedBox(height: 20),
              PaymentStatusCards(
                totalPaid: summary.totalPaid,
                totalPending: summary.totalPending,
              ),
              const SizedBox(height: 20),
              TotalCard(
                label: "Total",
                amount: summary.totalAmount.toStringAsFixed(2),
                color: AppColors.accentColor,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Purchase Details:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) =>
                              PurchaseProduct(clientId: currentClient.id),
                        ),
                      )
                          .then((value) {
                        // Re-fetch the client purchases after returning
                        _fetchClientPurchases();
                        setState(() {}); // Trigger UI rebuild
                      });
                    },
                    child: const Text(
                      "Order",
                      style: TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PurchaseDetailsList(
                purchases: clientPurchases,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PurchaseSummary _calculatePurchasesSummary(List<Purchase> purchases) {
    int totalPurchases = purchases.length;
    double totalAmount =
        purchases.fold(0.0, (sum, purchase) => sum + purchase.totalAmount);
    double totalPaid =
        purchases.fold(0.0, (sum, purchase) => sum + purchase.totalPayment);
    double totalPending = totalAmount - totalPaid;

    return PurchaseSummary(
      totalPurchases: totalPurchases,
      totalAmount: totalAmount,
      totalPaid: totalPaid,
      totalPending: totalPending,
    );
  }
}
