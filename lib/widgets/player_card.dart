import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/player_entry.dart';
import '../screens/player_detail.dart';
import '../screens/active_player_edit.dart';

class PlayerCard extends StatelessWidget {
  final PlayerEntry player;
  final String? imageUrl;
  final VoidCallback? onChanged;
  final String baseUrl;

  const PlayerCard({
    super.key,
    required this.player,
    required this.baseUrl,
    this.imageUrl,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final posisiText = posisiValues.reverse[player.posisi] ?? "";

    return Card(
      color: const Color(0xFFFFF5F5),
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
            aspectRatio: 4.3 / 3,
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
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.nama,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFFAA1515),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$posisiText • ${player.klub}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  "Umur: ${player.umur} tahun",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  "Market Value: €${player.marketValue.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFAA1515),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayerDetailPage(playerId: player.id),
                        ),
                      );
                    },
                    child: const Text(
                      "Detail Pemain",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFAA1515),
                      side:
                      const BorderSide(color: Color(0xFFAA1515), width: 0.6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => EditPlayerForm(
                          player: player,
                          baseUrl: baseUrl,
                        ),
                      );

                      if (ok == true) {
                        onChanged?.call(); // refresh list
                      }
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFAA1515),
                      side:
                      const BorderSide(color: Color(0xFFAA1515), width: 0.6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final ok = await _confirmDelete(context);
                      if (ok != true) return;

                      final request = context.read<CookieRequest>();
                      final success = await _deletePlayer(request);

                      if (!context.mounted) return;

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Pemain berhasil dihapus")),
                        );
                        onChanged?.call();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Gagal menghapus pemain")),
                        );
                      }
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(fontWeight: FontWeight.w700),
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

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: const Text("Hapus pemain?"),
        content: Text("Yakin mau hapus ${player.nama}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFAA1515),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Future<bool> _deletePlayer(CookieRequest request) async {
    final url = "$baseUrl/ProfileAktif/delete-flutter/${player.id}/";
    try {
      final res = await request.post(url, {});
      return (res is Map && res["status"] == "success");
    } catch (_) {
      return false;
    }
  }
}
