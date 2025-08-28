import 'package:flutter/material.dart';
import 'game_card.dart';
import 'game_processor.dart';
import 'dialogs/deposit_dialog.dart';

class CardsList extends StatelessWidget {
  const CardsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GameCard(
          title: 'Welcome to Mega 6/45',
          icon: Icons.sports_esports,
          onGameTap: () => openGame('mega645', 0),
          buttonImageURL:
              'https://img.fabet.to/bmp/826a0e5844bec3286d8b2f9bf7cf65a6/game/vi/techplay_mega_645.avif?hdsff?a=6',
        ),
        SizedBox(height: 30),

        GameCard(
          title: 'Welcome to Quay số 2\n(will open the right game when its ready)',
          icon: Icons.sports_esports,
          onGameTap: () => openGame('mega645', 0),
          buttonImageURL:
              'https://v4.five88.vin/2024/10/20/quay_so_2_1729426088.webp',
        ),
        SizedBox(height: 30),

        // Test button for deposit (có thể xóa trong production)
        TextButton.icon(
          onPressed: () => showDepositDialog(),
          icon: Icon(Icons.account_balance_wallet, color: Colors.grey),
          label: Text(
            'Test Deposit Dialog',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
