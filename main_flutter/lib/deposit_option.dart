import 'package:flutter/material.dart';
import 'utils/navigation_service.dart';
import 'dialogs/dialogs.dart';

Widget buildDepositOptions(BuildContext dialogContext) {
  final amounts = [50000, 100000, 200000, 500000, 1000000, 2000000];

  return Column(
    children: amounts.map((amount) {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {
            Navigator.of(dialogContext).pop();
            _processDeposit(amount);
          },
          child: Text(
            formatCurrency(amount),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }).toList(),
  );
}

String formatCurrency(int amount) {
  return '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VND';
}

Future<void> _processDeposit(int amount) async {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  // Show loading dialog
  showLoadingDialog(context);

  try {
    // Simulate API call for deposit
    await Future.delayed(Duration(seconds: 2));

    // Close loading dialog
    Navigator.of(context).pop();

    // Show success dialog
    showSuccessDialog(context, amount);
  } catch (e) {
    // Close loading dialog
    Navigator.of(context).pop();

    // Show error dialog
    showErrorDialog(context, 'Nạp tiền thất bại: $e');
  }
}
