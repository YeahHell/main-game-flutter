import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainGameApp extends StatefulWidget {
  const MainGameApp({super.key});
  @override
  State<MainGameApp> createState() => _MainGameAppState();
}

class _MainGameAppState extends State<MainGameApp> {
  static const _ch = MethodChannel('ksport_minigame');
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _ch.setMethodCallHandler((call) async {
      print('Received method call: ${call.method}'); // Debug log

      switch (call.method) {
        case 'gameClosed':
          print('Game closed from native side');
          break;
        case 'openDeposit':
          print('Opening deposit dialog...'); // Debug log
          // Sử dụng GlobalKey để đảm bảo có đúng context với MaterialLocalizations
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final context = navigatorKey.currentContext;
            if (context != null) {
              _showDepositDialog(context);
            } else {
              print('Navigator context not available');
            }
          });
          break;
        default:
          print('Unknown method: ${call.method}');
      }
    });
  }

  Future<void> _openSB() async {
    try {
      await _ch.invokeMethod('presentGame', {
        'tpToken': '4-46c4619603e7b48b4966d40e6c3aa455',
        'agentId': '4',
        'meta': {
          'uid': 'k_sports_ksport',
          'environment': 'production',
          'apiBaseUrl': 'https://apps-gateway.preprod.nana.codes',
          'sbBaseUrl': 'https://gali.sb21.net',
          'apiVersion': 'v2',
          'wssSbBaseUrl': 'wss://anten.sb21.net',
        }
      });
    } catch (e) {
      print('Error opening SB: $e');
      final context = navigatorKey.currentContext;
      if (context != null) {
        _showErrorDialog(context, 'Failed to open game: $e');
      }
    }
  }

  void _showDepositDialog([BuildContext? dialogContext]) {
    print('_showDepositDialog called'); // Debug log

    final BuildContext? targetContext = dialogContext ?? navigatorKey.currentContext;

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                _buildDepositOptions(context),
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

  Widget _buildDepositOptions(BuildContext dialogContext) {
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
              _formatCurrency(amount),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatCurrency(int amount) {
    return '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} VND';
  }

  Future<void> _processDeposit(int amount) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Show loading dialog
    _showLoadingDialog(context);

    try {
      // Simulate API call for deposit
      await Future.delayed(Duration(seconds: 2));

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success dialog
      _showSuccessDialog(context, amount);

    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show error dialog
      _showErrorDialog(context, 'Nạp tiền thất bại: $e');
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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

  void _showSuccessDialog(BuildContext context, int amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text('Thành Công!'),
            ],
          ),
          content: Text(
            'Nạp ${_formatCurrency(amount)} thành công!\nSố dư của bạn đã được cập nhật.',
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
              onPressed: () {
                Navigator.of(context).pop();
                // Có thể mở lại game sau khi nạp tiền thành công
                _openSB();
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'Main Game 🎮',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.sports_esports,
                        size: 80,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Welcome to K-Sport',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tap the button below to start playing!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        onPressed: _openSB,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Open SB Game',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Test button for deposit (có thể xóa trong production)
                TextButton.icon(
                  onPressed: () => _showDepositDialog(),
                  icon: Icon(Icons.account_balance_wallet, color: Colors.grey),
                  label: Text(
                    'Test Deposit Dialog',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}