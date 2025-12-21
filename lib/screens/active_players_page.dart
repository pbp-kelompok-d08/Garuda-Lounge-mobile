import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/player_entry.dart';
import '../widgets/left_drawer.dart';
import '../widgets/player_card.dart';

const Color red = Color(0xFFAA1515);
const Color white = Color(0xFFFFFFFF);
const Color cream = Color(0xFFE7E3DD);

class ActivePlayersPage extends StatefulWidget {
  const ActivePlayersPage({super.key});

  @override
  State<ActivePlayersPage> createState() => _ActivePlayersPageState();
}

class _ActivePlayersPageState extends State<ActivePlayersPage> {
  String _selectedPositionCode = "";
  Future<List<PlayerEntry>>? _futurePlayers;

  String get _baseUrl => "http://127.0.0.1:8000";

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

  void _refresh(CookieRequest request) {
    setState(() {
      _futurePlayers = fetchPlayers(request);
    });
  }

  Future<void> _openAddPlayerDialog(CookieRequest request) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _AddPlayerDialog(baseUrl: _baseUrl),
    );

    if (result == true) {
      _refresh(request);
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
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _openAddPlayerDialog(request),
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3 / 4.2,
                    ),
                    itemBuilder: (context, index) {
                      final player = filteredPlayers[index];
                      final photoUrl = buildPhotoUrl(player.foto);
                      return PlayerCard(
                        player: player,
                        imageUrl: photoUrl,
                        baseUrl: _baseUrl,
                        onChanged: () => _refresh(request),
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

class _AddPlayerDialog extends StatefulWidget {
  final String baseUrl;
  const _AddPlayerDialog({required this.baseUrl});

  @override
  State<_AddPlayerDialog> createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<_AddPlayerDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nama = TextEditingController();
  final _klub = TextEditingController();
  final _umur = TextEditingController();
  final _marketValue = TextEditingController();
  final _foto = TextEditingController();

  String _posisi = "GK";
  bool _loading = false;

  bool _isValidUrl(String s) {
    final uri = Uri.tryParse(s);
    if (uri == null) return false;
    if (!(uri.hasScheme && (uri.scheme == "http" || uri.scheme == "https"))) return false;
    return uri.host.isNotEmpty;
  }

  String _sanitizeMarketValue(String input) {
    var s = input.trim();
    s = s.replaceAll(",", ".");
    s = s.replaceAll(RegExp(r"[^0-9.]"), "");
    if (s.isEmpty) return "0";
    final firstDot = s.indexOf(".");
    if (firstDot != -1) {
      s = s.substring(0, firstDot + 1) + s.substring(firstDot + 1).replaceAll(".", "");
    }
    return s;
  }

  @override
  void dispose() {
    _nama.dispose();
    _klub.dispose();
    _umur.dispose();
    _marketValue.dispose();
    _foto.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final request = context.read<CookieRequest>();
    final payload = {
      "nama": _nama.text.trim(),
      "posisi": _posisi,
      "klub": _klub.text.trim(),
      "umur": int.tryParse(_umur.text.trim()) ?? 0,
      "market_value": double.tryParse(_sanitizeMarketValue(_marketValue.text)) ?? 0.0,
      "foto": _foto.text.trim(),
    };

    try {
      final res = await request.post(
        "${widget.baseUrl}/ProfileAktif/create-flutter/",
        payload,
      );

      if (!context.mounted) return;

      if (res is Map && res["status"] == "success") {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal tambah pemain")),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal tambah pemain")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tambah Pemain"),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nama,
                  decoration: const InputDecoration(labelText: "Nama"),
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Wajib diisi" : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _posisi,
                  decoration: const InputDecoration(labelText: "Posisi"),
                  items: const [
                    DropdownMenuItem(value: "GK", child: Text("Goalkeeper")),
                    DropdownMenuItem(value: "DF", child: Text("Defender")),
                    DropdownMenuItem(value: "MF", child: Text("Midfielder")),
                    DropdownMenuItem(value: "FW", child: Text("Forward")),
                  ],
                  onChanged: (v) => setState(() => _posisi = v ?? "GK"),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _klub,
                  decoration: const InputDecoration(labelText: "Klub"),
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Wajib diisi" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _umur,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Umur"),
                  validator: (v) {
                    final n = int.tryParse((v ?? "").trim());
                    if (n == null) return "Harus angka";
                    if (n <= 0 || n > 60) return "Umur tidak valid";
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _marketValue,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: "Market Value (€)"),
                  validator: (v) {
                    final s = _sanitizeMarketValue(v ?? "");
                    final n = double.tryParse(s);
                    if (n == null) return "Harus angka (boleh titik)";
                    if (n < 0) return "Tidak boleh minus";
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _foto,
                  decoration: const InputDecoration(labelText: "URL Foto"),
                  validator: (v) {
                    final s = (v ?? "").trim();
                    if (s.isEmpty) return "URL wajib";
                    if (!_isValidUrl(s)) return "Harus URL http/https valid";
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: _loading ? null : _submit,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFAA1515),
            foregroundColor: Colors.white,
          ),
          child: _loading
              ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
              : const Text("Simpan"),
        ),
      ],
    );
  }
}
