import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:stock_manage/constants/app_colors.dart';
import 'package:stock_manage/models/client_model.dart';
import 'package:stock_manage/models/purchase_model.dart';
import 'package:stock_manage/utils/global.dart';

class GenerateBillView extends StatefulWidget {
  final Client client;

  const GenerateBillView({super.key, required this.client});

  @override
  State<GenerateBillView> createState() => _GenerateBillViewState();
}

class _GenerateBillViewState extends State<GenerateBillView> {
  String filterType = 'both';

  List<Purchase> getFilteredPurchases() {
    List<Purchase> clientPurchases = Global.purchases
        .where((purchase) => purchase.clientId == widget.client.id)
        .toList();

    switch (filterType) {
      case 'pending':
        return clientPurchases
            .where((purchase) => purchase.pendingPayment > 0)
            .toList();
      case 'paid':
        return clientPurchases
            .where((purchase) => purchase.pendingPayment == 0)
            .toList();
      case 'both':
      default:
        return clientPurchases;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPurchases = getFilteredPurchases();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Bill'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClientDetails(),
            const SizedBox(height: 16),
            _buildFilterOptions(),
            const SizedBox(height: 16),
            Expanded(child: _buildPurchaseList(filteredPurchases)),
            _buildGeneratePdfButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildClientDetails() {
    return Card(
      child: ListTile(
        title: Text(widget.client.clientName),
        subtitle: Text('Email: ${widget.client.email}'),
        trailing: Text('Contact: ${widget.client.contact}'),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Filter:"),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: filterType,
          items: const [
            DropdownMenuItem(value: 'pending', child: Text("Pending Orders")),
            DropdownMenuItem(value: 'paid', child: Text("Paid Orders")),
            DropdownMenuItem(value: 'both', child: Text("Both")),
          ],
          onChanged: (value) {
            setState(() {
              filterType = value ?? 'both';
            });
          },
        ),
      ],
    );
  }

  Widget _buildPurchaseList(List<Purchase> purchases) {
    if (purchases.isEmpty) {
      return const Center(child: Text('No orders found.'));
    }
    return ListView.builder(
      itemCount: purchases.length,
      itemBuilder: (context, index) {
        final purchase = purchases[index];
        final product =
            Global.products.firstWhere((prod) => prod.id == purchase.productId);

        return ListTile(
          title: Text('Product: ${product.name}'),
          subtitle: Text(
            'Total Amount: \$${purchase.totalAmount.toStringAsFixed(2)} - Paid: \$${purchase.totalPayment.toStringAsFixed(2)}',
          ),
          trailing:
              Text('Pending: \$${purchase.pendingPayment.toStringAsFixed(2)}'),
        );
      },
    );
  }

  Widget _buildGeneratePdfButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _generatePdfPreview,
        child: const Text("View PDF Design"),
      ),
    );
  }

  void _generatePdfPreview() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Client Details',
                  style: const pw.TextStyle(fontSize: 24)),
              pw.Text('Name: ${widget.client.clientName}'),
              pw.Text('Email: ${widget.client.email}'),
              pw.Text('Contact: ${widget.client.contact}'),
              pw.SizedBox(height: 20),
              pw.Text('Purchase Details',
                  style: const pw.TextStyle(fontSize: 20)),
              pw.ListView.builder(
                itemCount: getFilteredPurchases().length,
                itemBuilder: (context, index) {
                  final purchase = getFilteredPurchases()[index];
                  final product = Global.products
                      .firstWhere((prod) => prod.id == purchase.productId);
                  return pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(product.name),
                      pw.Text(
                          'Total: \$${purchase.totalAmount.toStringAsFixed(2)}'),
                      pw.Text(
                          'Paid: \$${purchase.totalPayment.toStringAsFixed(2)}'),
                      pw.Text(
                          'Pending: \$${purchase.pendingPayment.toStringAsFixed(2)}'),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
