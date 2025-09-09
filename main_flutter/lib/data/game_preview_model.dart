import 'package:flutter/material.dart';

enum GameType { basic, sb }

class GamePreviewModel {
  final String id;
  final String name;
  final IconData icon;
  final String imageUrl;
  final GameType type;

  GamePreviewModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.imageUrl,
    required this.type,
  });
}

final List<GamePreviewModel> games = [
  GamePreviewModel(
    id: 'mega645',
    name: 'Welcome to Mega 6/45',
    icon: Icons.sports_esports,
    imageUrl:
        'https://img.fabet.to/bmp/826a0e5844bec3286d8b2f9bf7cf65a6/game/vi/techplay_mega_645.avif?hdsff?a=6',
    type: GameType.basic,
  ),
  GamePreviewModel(
    id: 'power655',
    name: 'Welcome to Power 6/55',
    icon: Icons.sports_esports,
    imageUrl:
        'https://img.fabet.to/bmp/826a0e5844bec3286d8b2f9bf7cf65a6/game/vi/techplay_power_655.avif?hdsff?a=7',
    type: GameType.basic,
  ),

  GamePreviewModel(
    id: 'ksport_minigame',
    name: 'K-Sports',
    icon: Icons.sports_esports,
    imageUrl:
        'https://img.fabet.to/bmp/826a0e5844bec3286d8b2f9bf7cf65a6/game/vi/ksports_landscape.avif?LCXPt?a=6',
    type: GameType.sb,
  ),
];
