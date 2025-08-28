import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dialogs/deposit_dialog.dart';
import 'navigation_service.dart';


class MethodChannelHelper {
  static Future<void> handleMethodCall(
      BuildContext? context,
      MethodCall call,
      ) async {
    print('Received method call: ${call.method}'); // Debug log
    print('call arguments: ${call.arguments}');
    // we can pass this arguments to understand what app should be returned etc

    switch (call.method) {
      case 'gameClosed':
        print('Game closed from native side');
        break;

      case 'openDeposit':
        print('Opening deposit dialog...'); // Debug log

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = context ?? navigatorKey.currentContext;
          if (ctx != null) {
            showDepositDialog(ctx);
          } else {
            print('Navigator context not available');
          }
        });
        break;

      default:
        print('Unknown method: ${call.method}');
    }
  }
}