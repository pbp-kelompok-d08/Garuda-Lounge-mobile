import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/player_entry.dart';
import '../widgets/left_drawer.dart';
import '../widgets/player_card.dart';

class ActivePlayersPage extends StatefulWidget {
  const ActivePlayersPage({super.key});

  @override
  State<ActivePlayersPage> createState() => _ActivePlayersPageState();
}

class _ActivePlayersPageState extends State<ActivePlayersPage> {
  String _selectedPositionCode = ""; // "", GK, DF, MF, FW

  Future<List<PlayerEntry>> fetchPlayers(CookieRequest request) async {
    final response =
    await request.get("http://localhost:8000/ProfileAktif/json/");

    return List<PlayerEntry>.from(
      response.map((item) => PlayerEntry.fromJson(item)),
    );
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
        title: const Text("Daftar Pemain Aktif"),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<PlayerEntry>>(
        future: fetchPlayers(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child:
              Text("Terjadi masalah: ${snapshot.error}", textAlign: TextAlign.center),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Belum ada pemain aktif terdaftar"),
            );
          }

          final allPlayers = snapshot.data!;
          final filteredPlayers = _selectedPositionCode.isEmpty
              ? allPlayers
              : allPlayers.where((p) {
            final kode = posisiKodeValues.reverse[p.posisiKode] ?? "";
            return kode == _selectedPositionCode;
          }).toList();

          if (filteredPlayers.isEmpty) {
            return const Center(
              child: Text("Tidak ada pemain untuk posisi ini"),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 220,
                    ),
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFAA1515), // var(--red)
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // border-radius: 10px
                        ),
                        elevation: 4, // box-shadow
                        shadowColor: const Color(0x38AA1515), // rgba(170,21,21,.22)
                        overlayColor: const Color(0xFF8B1010), // hover: #8b1010
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 18,
                      ),
                      label: const Text(
                        "Back to Main Page",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Text(
                    "Pemain Aktif Timnas Indonesia",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFAA1515),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text(
                      "Filter posisi",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value:
                      _selectedPositionCode.isEmpty ? null : _selectedPositionCode,
                      hint: const Text("Semua posisi"),
                      items: const [
                        DropdownMenuItem(
                          value: "GK",
                          child: Text("Goalkeeper"),
                        ),
                        DropdownMenuItem(
                          value: "DF",
                          child: Text("Defender"),
                        ),
                        DropdownMenuItem(
                          value: "MF",
                          child: Text("Midfielder"),
                        ),
                        DropdownMenuItem(
                          value: "FW",
                          child: Text("Forward"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPositionCode = value ?? "";
                        });
                      },
                    ),
                    const Spacer(),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFAA1515),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                            Text("Form tambah pemain dari Flutter belum dibuat"),
                          ),
                        );
                      },
                      child: const Text(
                        "+ Tambah Pemain",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    itemCount: filteredPlayers.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 card per baris, mirip responsive
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3 / 4,
                    ),
                    itemBuilder: (context, index) {
                      final player = filteredPlayers[index];
                      final photoUrl = buildPhotoUrl(player.foto);
                      return PlayerCard(
                        player: player,
                        imageUrl: photoUrl,
                      );
                    },
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
