import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
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
              // Company Name
              pw.Text('Your Company Name',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 8),
              // Contact Info
              pw.Text('Contact: +91 123 4567 890',
                  style: const pw.TextStyle(fontSize: 14),
                  textAlign: pw.TextAlign.center),
              pw.Text('Email: xyz@gmail.com',
                  style: const pw.TextStyle(fontSize: 14),
                  textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 20),
              // Client Details
              pw.Text('Client Details',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Text('Name: ${widget.client.clientName}'),
              pw.Text('Email: ${widget.client.email}'),
              pw.Text('Contact: ${widget.client.contact}'),
              pw.SizedBox(height: 20),
              // Purchase Details
              pw.Text('Purchase Details',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              // Updated to use TableHelper
              pdfWidgets.TableHelper.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Product Name', 'Total Amount', 'Paid', 'Pending'],
                  ...getFilteredPurchases().map((purchase) {
                    final product = Global.products
                        .firstWhere((prod) => prod.id == purchase.productId);
                    return [
                      product.name,
                      '\$${purchase.totalAmount.toStringAsFixed(2)}',
                      '\$${purchase.totalPayment.toStringAsFixed(2)}',
                      '\$${purchase.pendingPayment.toStringAsFixed(2)}',
                    ];
                  }),
                ],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellStyle: const pw.TextStyle(),
                border: pw.TableBorder.all(),
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
