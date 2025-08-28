import 'utils/navigation_service.dart';
import 'dialogs/dialogs.dart';

Future<void> openGame(String id, int amount) async {
  try {
    await ch.invokeMethod(id, {
      'tpToken': '4-46c4619603e7b48b4966d40e6c3aa455',
      'balance': amount,
    });
  } catch (e) {
    print('Error opening game: $e');
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      showErrorDialog(context, 'Failed to open game: $e');
    }
  }
}

Future<void> openSB() async {
  try {
    await ch.invokeMethod('ksport_minigame', {
      'tpToken': '4-46c4619603e7b48b4966d40e6c3aa455',
      'agentId': '4',
      'meta': {
        'uid': 'k_sports_ksport',
        'environment': 'production',
        'apiBaseUrl': 'https://apps-gateway.preprod.nana.codes',
        'sbBaseUrl': 'https://gali.sb21.net',
        'apiVersion': 'v2',
        'wssSbBaseUrl': 'wss://anten.sb21.net',
      },
    });
  } catch (e) {
    print('Error opening SB: $e');
    final context = navigatorKey.currentContext;
    if (context != null) {
      showErrorDialog(context, 'Failed to open game: $e');
    }
  }
}
