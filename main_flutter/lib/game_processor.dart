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
