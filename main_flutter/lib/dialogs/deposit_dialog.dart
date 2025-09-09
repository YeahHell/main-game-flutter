import 'package:flutter/material.dart';
import '../utils/navigation_service.dart';
import '../deposit_option.dart';

void showDepositDialog(String? gameID, [BuildContext? dialogContext]) {
  print('_showDepositDialog called'); // Debug log

  final BuildContext? targetContext =
      dialogContext ?? navigatorKey.currentContext;

  // Đảm bảo context có MaterialLocalizations
  if (targetContext == null) {
    print('No valid context available');
    return;
  }

  showDialog(
    context: targetContext,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.green),
            SizedBox(width: 8),
            Text('Nạp Tiền'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chọn số tiền muốn nạp:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              buildDepositOptions(context, gameID),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
        ],
      );
    },
  );
}
