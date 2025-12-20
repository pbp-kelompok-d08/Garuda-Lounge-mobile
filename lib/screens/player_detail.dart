import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/player_entry.dart';

class PlayerDetailPage extends StatefulWidget {
  final String playerId;

  const PlayerDetailPage({super.key, required this.playerId});

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  Future<PlayerEntry> fetchPlayerDetail(CookieRequest request) async {
    final response = await request.get(
      "http://localhost:8000/ProfileAktif/json/${widget.playerId}/",
    );

    return PlayerEntry.fromJson(response[0]);
  }

  String buildPhotoUrl(String rawUrl) {
    if (rawUrl.isEmpty) return "";
    final encoded = Uri.encodeComponent(rawUrl);
    return "http://localhost:8000/ProfileAktif/proxy-image/?url=$encoded";
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pemain"),
        backgroundColor: const Color(0xFFAA1515),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<PlayerEntry>(
        future: fetchPlayerDetail(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFAA1515)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Terjadi error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Data pemain tidak ditemukan"));
          }

          final player = snapshot.data!;
          final posisiText = posisiValues.reverse[player.posisi] ?? "";
          final photoUrl = buildPhotoUrl(player.foto);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // BACK BUTTON
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFAA1515),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      shadowColor: const Color(0x38AA1515),
                      overlayColor: const Color(0xFF8B1010),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text(
                      "Back",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // FOTO
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: photoUrl.isNotEmpty
                      ? Image.network(
                    photoUrl,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 240,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 70),
                  ),
                ),

                const SizedBox(height: 24),

                // CARD DETAIL
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFAA1515), width: 1.4),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33AA1515),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama
                      Text(
                        player.nama,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFAA1515),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Posisi + Klub
                      DetailTile(
                        title: "Posisi",
                        value: posisiText,
                      ),
                      DetailTile(
                        title: "Klub",
                        value: player.klub,
                      ),

                      // Umur
                      DetailTile(
                        title: "Umur",
                        value: "${player.umur} tahun",
                      ),

                      // Market Value
                      DetailTile(
                        title: "Market Value",
                        value: "€${player.marketValue.toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Widget kecil untuk baris detail
class DetailTile extends StatelessWidget {
  final String title;
  final String value;

  const DetailTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
