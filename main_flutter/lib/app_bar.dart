import 'package:flutter/material.dart';
import 'data/local_data_manager.dart';
import 'dialogs/deposit_dialog.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Aggregator',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ValueListenableBuilder<int>(
              valueListenable: balanceManager,
              builder: (context, balance, _) => ElevatedButton.icon(
                  onPressed: () => showDepositDialog(null),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                  ),
                  icon: const Icon(Icons.account_balance_wallet, size: 18, color: Colors.black),
                  label: Text(
                    '\$${balanceManager.value}',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                )
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}
