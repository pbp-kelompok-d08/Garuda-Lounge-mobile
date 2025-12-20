import 'package:flutter/material.dart';
import '../models/player_entry.dart';
import '../screens/player_detail.dart';


class PlayerCard extends StatelessWidget {
  final PlayerEntry player;
  final String? imageUrl;

  const PlayerCard({
    super.key,
    required this.player,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final posisiText = posisiValues.reverse[player.posisi] ?? "";

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFAA1515)),
      ),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.person, size: 40),
                );
              },
            )
                : Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.person, size: 40),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFFAA1515),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$posisiText • ${player.klub}",
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  "Umur: ${player.umur} tahun",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  "Market Value: €${player.marketValue.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFAA1515),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PlayerDetailPage(playerId: player.id),
                        ),
                      );
                    },
                    child: const Text(
                      "Detail Pemain",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
