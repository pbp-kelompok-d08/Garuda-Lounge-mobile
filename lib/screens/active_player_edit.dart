import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/player_entry.dart';

const Color dsRed = Color(0xFFAA1515);
const Color dsWhite = Color(0xFFFFFFFF);
const Color modalBg = Color(0xFFFFF5F5);
const Color dsBlack = Color(0xFF111111);

class EditPlayerForm extends StatefulWidget {
  final PlayerEntry player;
  final String baseUrl;

  const EditPlayerForm({
    super.key,
    required this.player,
    this.baseUrl = "https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id",
  });

  @override
  State<EditPlayerForm> createState() => _EditPlayerFormState();
}

class _EditPlayerFormState extends State<EditPlayerForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _namaController;
  late final TextEditingController _klubController;
  late final TextEditingController _umurController;
  late final TextEditingController _marketValueController;
  late final TextEditingController _fotoController;

  String _posisiKode = "MF";
  bool _isSubmitting = false;
  String? _error;

  // ====== STYLE (samain kayak modal tambah pemain) ======
  TextStyle get _labelStyle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: dsBlack,
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
      fillColor: dsWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: dsRed, width: 1.8),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.red, width: 1.4),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.red, width: 1.8),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _namaController = TextEditingController(text: widget.player.nama);
    _klubController = TextEditingController(text: widget.player.klub);
    _umurController = TextEditingController(text: widget.player.umur.toString());
    _marketValueController = TextEditingController(
      text: widget.player.marketValue.toStringAsFixed(2),
    );
    _fotoController = TextEditingController(text: widget.player.foto);

    // enum -> "GK/DF/MF/FW"
    final kode = posisiKodeValues.reverse[widget.player.posisiKode];
    if (kode != null && ["GK", "DF", "MF", "FW"].contains(kode)) {
      _posisiKode = kode;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _klubController.dispose();
    _umurController.dispose();
    _marketValueController.dispose();
    _fotoController.dispose();
    super.dispose();
  }

  String? _validateRequiredText(String? v, String label) {
    final value = (v ?? "").trim();
    if (value.isEmpty) return "$label wajib diisi";
    return null;
  }

  String? _validateUmur(String? v) {
    final value = (v ?? "").trim();
    if (value.isEmpty) return "Umur wajib diisi";
    final umur = int.tryParse(value);
    if (umur == null) return "Umur harus angka";
    if (umur <= 0) return "Umur harus > 0";
    return null;
  }

  String? _validateMarketValue(String? v) {
    final value = (v ?? "").trim();
    if (value.isEmpty) return "Market value wajib diisi";
    if (value.contains(",")) {
      return "Jangan pakai koma, pakai titik (.)";
    }
    final mv = double.tryParse(value);
    if (mv == null) return "Market value harus angka";
    if (mv < 0) return "Market value tidak boleh negatif";
    return null;
  }

  String? _validateUrl(String? v) {
    final value = (v ?? "").trim();
    if (value.isEmpty) return "Foto wajib URL";
    final uri = Uri.tryParse(value);
    if (uri == null) return "URL tidak valid";
    if (!(uri.hasScheme && (uri.scheme == "http" || uri.scheme == "https"))) {
      return "URL harus diawali http/https";
    }
    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    final request = context.read<CookieRequest>();

    final payload = {
      "nama": _namaController.text.trim(),
      "posisi": _posisiKode, // GK/DF/MF/FW
      "klub": _klubController.text.trim(),
      "umur": int.parse(_umurController.text.trim()),
      // kirim string biar aman di backend Decimal(str(...))
      "market_value": _marketValueController.text.trim(),
      "foto": _fotoController.text.trim(),
    };

    final url = "${widget.baseUrl}/ProfileAktif/edit-flutter/${widget.player.id}/";

    try {
      final res = await request.post(url, jsonEncode(payload));

      if (!mounted) return;

      if (res is Map && res["status"] == "success") {
        Navigator.pop(context, true);
        return;
      }

      String msg = "Gagal update pemain";
      if (res is Map) {
        if (res["message"] != null) msg = res["message"].toString();
        if (res["errors"] is Map) {
          final errs = (res["errors"] as Map).values.map((e) => e.toString()).toList();
          if (errs.isNotEmpty) msg = errs.join("\n");
        }
      }

      setState(() => _error = msg);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = "Error: $e");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      backgroundColor: modalBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: dsRed, width: 2), // border merah DS
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: viewInsets), // aman keyboard
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
                          "Edit Pemain Aktif",
                          style: TextStyle(
                            color: dsRed,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _isSubmitting ? null : () => Navigator.pop(context, false),
                        icon: Icon(Icons.close, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),

                // BODY (SCROLL)
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
                            controller: _namaController,
                            decoration: _dec("Masukkan nama pemain"),
                            validator: (v) => _validateRequiredText(v, "Nama"),
                          ),
                          const SizedBox(height: 18),

                          Text("Posisi", style: _labelStyle),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _posisiKode,
                            decoration: _dec("Pilih posisi"),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            dropdownColor: dsWhite,
                            items: const [
                              DropdownMenuItem(value: "GK", child: Text("Goalkeeper")),
                              DropdownMenuItem(value: "DF", child: Text("Defender")),
                              DropdownMenuItem(value: "MF", child: Text("Midfielder")),
                              DropdownMenuItem(value: "FW", child: Text("Forward")),
                            ],
                            onChanged: _isSubmitting
                                ? null
                                : (v) => setState(() => _posisiKode = v ?? "MF"),
                          ),
                          const SizedBox(height: 18),

                          Text("Klub", style: _labelStyle),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _klubController,
                            decoration: _dec("Nama klub pemain"),
                            validator: (v) => _validateRequiredText(v, "Klub"),
                          ),
                          const SizedBox(height: 18),

                          Text("Umur", style: _labelStyle),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _umurController,
                            keyboardType: TextInputType.number,
                            decoration: _dec("Masukkan umur"),
                            validator: _validateUmur,
                          ),
                          const SizedBox(height: 18),

                          Text("Market Value (Rp)", style: _labelStyle),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _marketValueController,
                            keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                            decoration: _dec("Contoh: 150000"),
                            validator: _validateMarketValue,
                          ),
                          const SizedBox(height: 18),

                          Text("URL Foto", style: _labelStyle),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _fotoController,
                            keyboardType: TextInputType.url,
                            decoration: _dec("Masukkan URL foto pemain"),
                            validator: _validateUrl,
                          ),

                          if (_error != null) ...[
                            const SizedBox(height: 14),
                            Text(
                              _error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
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
                          side: const BorderSide(color: dsRed, width: 1.8),
                          foregroundColor: dsRed,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isSubmitting ? null : () => Navigator.pop(context, false),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: dsRed,
                          foregroundColor: dsWhite,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: dsWhite,
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
