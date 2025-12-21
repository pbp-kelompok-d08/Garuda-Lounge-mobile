import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/player_entry.dart';
import '../widgets/left_drawer.dart';
import '../widgets/player_card.dart';
import '../screens/active_player_form.dart';

const Color red = Color(0xFFAA1515);
const Color white = Color(0xFFFFFFFF);
const Color cream = Color(0xFFE7E3DD);
const Color black = Color(0xFF111111);

class ActivePlayersPage extends StatefulWidget {
  const ActivePlayersPage({super.key});

  @override
  State<ActivePlayersPage> createState() => _ActivePlayersPageState();
}

class _ActivePlayersPageState extends State<ActivePlayersPage> {
  String _selectedPositionCode = "";
  Future<List<PlayerEntry>>? _futurePlayers;

  String get _baseUrl => "http://localhost:8000";

  Future<List<PlayerEntry>> fetchPlayers(CookieRequest request) async {
    final response = await request.get("$_baseUrl/ProfileAktif/json/");
    return List<PlayerEntry>.from(
      response.map((item) => PlayerEntry.fromJson(item)),
    );
  }

  String buildPhotoUrl(String rawUrl) {
    if (rawUrl.isEmpty) return "";
    final encoded = Uri.encodeComponent(rawUrl);
    return "$_baseUrl/ProfileAktif/proxy-image/?url=$encoded";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      setState(() {
        _futurePlayers = fetchPlayers(request);
      });
    });
  }

  Future<void> _openAddPlayerModal(CookieRequest request) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ActivePlayerForm(
        createUrl: "$_baseUrl/ProfileAktif/create-flutter/",
      ),
    );

    if (ok == true) {
      setState(() {
        _futurePlayers = fetchPlayers(request);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text(
          "Daftar Pemain Aktif",
          style: TextStyle(
            color: red,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<PlayerEntry>>(
        future: _futurePlayers ?? fetchPlayers(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi masalah: ${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }

          final allPlayers = snapshot.data ?? [];
          if (allPlayers.isEmpty) {
            return const Center(
              child: Text("Belum ada pemain aktif terdaftar"),
            );
          }

          final filteredPlayers = _selectedPositionCode.isEmpty
              ? allPlayers
              : allPlayers.where((p) {
            final kode = posisiKodeValues.reverse[p.posisiKode] ?? "";
            return kode == _selectedPositionCode;
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: red,
                        foregroundColor: white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
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
                const Center(
                  child: Text(
                    "Pemain Aktif Timnas Indonesia",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: red,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text(
                      "Filter posisi",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<String>(
                        value: _selectedPositionCode,
                        isExpanded: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: red, width: 1.6),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: red, width: 2.0),
                          ),
                        ),
                        dropdownColor: white,
                        icon: const Icon(Icons.arrow_drop_down, color: red),
                        style: const TextStyle(
                          color: red,
                          fontWeight: FontWeight.w600,
                        ),
                        items: const [
                          DropdownMenuItem(value: "", child: Text("Semua posisi")),
                          DropdownMenuItem(value: "GK", child: Text("Goalkeeper")),
                          DropdownMenuItem(value: "DF", child: Text("Defender")),
                          DropdownMenuItem(value: "MF", child: Text("Midfielder")),
                          DropdownMenuItem(value: "FW", child: Text("Forward")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedPositionCode = value ?? "";
                          });
                        },
                      ),
                    ),
                    const Spacer(),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: red,
                        foregroundColor: white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _openAddPlayerModal(request),
                      child: const Text(
                        "+ Tambah Pemain",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredPlayers.isEmpty
                      ? const Center(child: Text("Tidak ada pemain untuk posisi ini"))
                      : GridView.builder(
                    itemCount: filteredPlayers.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3 / 4.3,
                    ),
                    itemBuilder: (context, index) {
                      final player = filteredPlayers[index];
                      final photoUrl = buildPhotoUrl(player.foto);
                      return PlayerCard(
                        player: player,
                        imageUrl: photoUrl,
                        baseUrl: _baseUrl,
                        onChanged: () {
                          setState(() {
                            _futurePlayers = fetchPlayers(request);
                          });
                        },
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
