import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/player_entry.dart';
import '../screens/player_detail.dart';
// import '../screens/player_edit.dart';

class PlayerCard extends StatelessWidget {
  final PlayerEntry player;
  final String? imageUrl;
  final VoidCallback? onChanged;
  final String baseUrl;

  const PlayerCard({
    super.key,
    required this.player,
    this.imageUrl,
    this.onChanged,
    this.baseUrl = "http://localhost:8000",
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
            padding: const EdgeInsets.all(10),
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
                const SizedBox(height: 12),

                // DETAIL
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFAA1515),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // EDIT (Outlined)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFAA1515),
                      side: const BorderSide(color: Color(0xFFAA1515), width: 0.6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      // Kalau kamu belum bikin page edit, biarin dulu tombolnya disabled/atau bikin dialog.
                      // Contoh kalau udah bikin page edit:
                      //
                      // final ok = await Navigator.push<bool>(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => PlayerEditPage(player: player, baseUrl: baseUrl),
                      //   ),
                      // );
                      // if (ok == true) onChanged?.call();

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Edit belum dibuat"),
                          content: const Text("Bikin halaman edit dulu ya. Nanti tombol ini bisa diarahkan ke page edit."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // DELETE (Outlined)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFAA1515),
                      side: const BorderSide(color: Color(0xFFAA1515), width: 0.6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
    try {
      final url = "$baseUrl/ProfileAktif/player/${player.id}/delete/";
      final res = await request.post(url, {});
      if (res is Map && res["success"] == true) return true;
      if (res is String) return true; // fallback kalau backend balikin string
      return false;
    } catch (_) {
      return false;
    }
  }
}
