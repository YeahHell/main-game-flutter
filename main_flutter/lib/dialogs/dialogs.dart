import 'package:flutter/material.dart';
import '../data/local_data_manager.dart';
import '../deposit_option.dart';
import '../game_processor.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 16),
            Text('Đang xử lý giao dịch...'),
          ],
        ),
      );
    },
  );
}

void showSuccessDialog(BuildContext context, int amount, String? gameID) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Thành Công!'),
          ],
        ),
        content: Text(
          'Nạp ${formatCurrency(amount)} thành công!\nSố dư của bạn đã được cập nhật.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              // Có thể mở lại game sau khi nạp tiền thành công
              // store in the shared preferences and pass amount
              await balanceManager.increment(
                'balance',
                by: amount,
                defaultValue: 0,
              );
              if (gameID == null) {
                print('Game ID not found');
              } else {
                openGame(gameID);
              }
            },
            child: Text('Tiếp Tục Chơi', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Đóng'),
          ),
        ],
      );
    },
  );
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Lỗi'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Đóng'),
          ),
        ],
      );
    },
  );
}
