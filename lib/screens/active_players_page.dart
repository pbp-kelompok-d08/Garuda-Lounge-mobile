import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/player_entry.dart';
import '../widgets/left_drawer.dart';
import '../widgets/player_card.dart';
import 'dart:convert';
import '../main.dart';

// sesuai request bg card/modal
const Color cardBg = Color(0xFFFFF5F5);

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

                      // TODO ✅ button ini cuma bisa diakses sama admin
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

  // ==== STYLE HELPERS (pict 3) ====
  TextStyle get _labelStyle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: Color(0xFF111111),
  );

  InputDecoration _dec(String hint) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.4),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: red, width: 1.8),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.red, width: 1.4),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.red, width: 1.8),
      ),
    );
  }

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
      final res = await request.postJson(
        "${widget.baseUrl}/ProfileAktif/create-flutter/",
        jsonEncode(payload),
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
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    // Pakai Dialog custom (bukan AlertDialog) biar styling bisa "full control"
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: red, width: 2),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: viewInsets),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 10, 10),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Tambah Pemain Aktif",
                          style: TextStyle(
                            color: red,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey.shade600),
                        onPressed: _loading ? null : () => Navigator.pop(context, false),
                      ),
                    ],
                  ),
                ),

                // BODY (SCROLLABLE)
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 6, 18, 14),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nama", style: _labelStyle),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _nama,
                            decoration: _dec("Masukkan nama pemain"),
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? "Wajib diisi" : null,
                          ),
                          const SizedBox(height: 18),

                          Text("Posisi", style: _labelStyle),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _posisi,
                            decoration: _dec("Pilih posisi"),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            dropdownColor: white,
                            items: const [
                              DropdownMenuItem(value: "GK", child: Text("Goalkeeper")),
                              DropdownMenuItem(value: "DF", child: Text("Defender")),
                              DropdownMenuItem(value: "MF", child: Text("Midfielder")),
                              DropdownMenuItem(value: "FW", child: Text("Forward")),
                            ],
                            onChanged: _loading ? null : (v) => setState(() => _posisi = v ?? "GK"),
                          ),
                          const SizedBox(height: 18),

                          Text("Klub", style: _labelStyle),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _klub,
                            decoration: _dec("Nama klub pemain"),
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? "Wajib diisi" : null,
                          ),
                          const SizedBox(height: 18),

                          Text("Umur", style: _labelStyle),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _umur,
                            keyboardType: TextInputType.number,
                            decoration: _dec("Masukkan umur"),
                            validator: (v) {
                              final n = int.tryParse((v ?? "").trim());
                              if (n == null) return "Harus angka";
                              if (n <= 0 || n > 60) return "Umur tidak valid";
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          Text("Market Value (Rp)", style: _labelStyle),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _marketValue,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: _dec("Contoh: 150000"),
                            validator: (v) {
                              final s = _sanitizeMarketValue(v ?? "");
                              final n = double.tryParse(s);
                              if (n == null) return "Harus angka (boleh titik)";
                              if (n < 0) return "Tidak boleh minus";
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          Text("URL Foto", style: _labelStyle),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _foto,
                            decoration: _dec("Masukkan URL foto pemain"),
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

                // FOOTER BUTTONS
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: red, width: 1.8),
                          foregroundColor: red,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _loading ? null : () => Navigator.pop(context, false),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: _loading ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: red,
                          foregroundColor: white,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: white,
                          ),
                        )
                            : const Text(
                          "Simpan",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
