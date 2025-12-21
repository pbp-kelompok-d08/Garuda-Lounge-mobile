import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/player_entry.dart';

const Color red = Color(0xFFAA1515);
const Color cream = Color(0xFFE7E3DD);
const Color white = Color(0xFFFFFFFF);

class PlayerDetailPage extends StatefulWidget {
  final String playerId;

  const PlayerDetailPage({super.key, required this.playerId});

  @override
  State<PlayerDetailPage> createState() => _PlayerDetailPageState();
}

class _PlayerDetailPageState extends State<PlayerDetailPage> {
  String get _baseUrl => "https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id";

  Future<PlayerEntry> fetchPlayerDetail(CookieRequest request) async {
    final response = await request.get("$_baseUrl/ProfileAktif/json/");

    final list = List<Map<String, dynamic>>.from(response);
    final found = list.firstWhere(
          (item) => item["id"].toString() == widget.playerId,
      orElse: () => <String, dynamic>{},
    );

    if (found.isEmpty) {
      throw Exception("Player tidak ditemukan");
    }

    return PlayerEntry.fromJson(found);
  }

  String buildPhotoUrl(String rawUrl) {
    final cleaned = rawUrl.trim();
    if (cleaned.isEmpty) return "";
    if (!(cleaned.startsWith("http://") || cleaned.startsWith("https://"))) return "";
    final encoded = Uri.encodeComponent(cleaned);
    return "$_baseUrl/ProfileAktif/proxy-image/?url=$encoded";
  }


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text("Detail Pemain"),
        backgroundColor: red,
        foregroundColor: white,
      ),
      body: FutureBuilder<PlayerEntry>(
        future: fetchPlayerDetail(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: red),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: white,
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
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text(
                      "Back",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: photoUrl.isNotEmpty
                      ? Image.network(
                    photoUrl,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) {
                      return Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: Text(
                          "Gagal load\n${error.toString()}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  )
                      : Container(
                    height: 240,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 70),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: red, width: 1.4),
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
                      Text(
                        player.nama,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DetailTile(title: "Posisi", value: posisiText),
                      DetailTile(title: "Klub", value: player.klub),
                      DetailTile(title: "Umur", value: "${player.umur} tahun"),
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
