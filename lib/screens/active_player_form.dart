import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

const Color red = Color(0xFFAA1515);
const Color white = Color(0xFFFFFFFF);
const Color black = Color(0xFF111111);

class ActivePlayerForm extends StatefulWidget {
  final String createUrl;

  const ActivePlayerForm({super.key, required this.createUrl});

  @override
  State<ActivePlayerForm> createState() => _ActivePlayerFormState();
}

class _ActivePlayerFormState extends State<ActivePlayerForm> {
  final _formKey = GlobalKey<FormState>();

  final _namaC = TextEditingController();
  final _klubC = TextEditingController();
  final _umurC = TextEditingController();
  final _marketC = TextEditingController();
  final _fotoC = TextEditingController();

  String? _posisi;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _namaC.dispose();
    _klubC.dispose();
    _umurC.dispose();
    _marketC.dispose();
    _fotoC.dispose();
    super.dispose();
  }

  InputDecoration _dec(String hint, {String? helper}) {
    return InputDecoration(
      hintText: hint,
      helperText: helper,
      filled: true,
      fillColor: white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: red, width: 1.8),
      ),
    );
  }

  String? _validateMarketValue(String? v) {
    final s = (v ?? "").trim();
    if (s.isEmpty) return "Market value wajib diisi.";
    if (s.contains(",")) return "Gunakan titik (.) sebagai desimal, bukan koma.";
    final ok = RegExp(r'^\d+(\.\d+)?$').hasMatch(s);
    if (!ok) return "Market value hanya boleh angka dan titik.";
    final d = double.tryParse(s);
    if (d == null) return "Market value tidak valid.";
    if (d < 0) return "Market value tidak boleh negatif.";

    final parts = s.split(".");
    if (parts.length == 2 && parts[1].length > 2) {
      return "Maksimal 2 angka di belakang titik.";
    }

    final intDigits = parts[0].replaceFirst(RegExp(r'^0+'), '');
    final totalDigits = (intDigits.isEmpty ? 1 : intDigits.length) +
        (parts.length == 2 ? parts[1].length : 0);
    if (totalDigits > 10) return "Terlalu besar (maks 10 digit total).";

    return null;
  }

  String? _validatePhotoUrl(String? v) {
    final s = (v ?? "").trim();
    if (s.isEmpty) return "URL foto wajib diisi.";
    final uri = Uri.tryParse(s);
    if (uri == null) return "URL foto tidak valid.";
    if (!(uri.hasScheme && (uri.scheme == "http" || uri.scheme == "https"))) {
      return "URL foto harus diawali http:// atau https://";
    }
    if (!uri.hasAuthority) return "URL foto tidak valid.";
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_posisi == null || _posisi!.isEmpty) {
      setState(() => _error = "Posisi wajib dipilih.");
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final request = context.read<CookieRequest>();

      final marketValue = double.parse(_marketC.text.trim());
      final umur = int.parse(_umurC.text.trim());

      final resp = await request.postJson(
        widget.createUrl,
        jsonEncode({
          "nama": _namaC.text.trim(),
          "posisi": _posisi,
          "klub": _klubC.text.trim(),
          "umur": umur,
          "market_value": marketValue,
          "foto": _fotoC.text.trim(),
        }),
      );

      if (resp is Map && resp["status"] == "success") {
        if (!mounted) return;
        Navigator.pop(context, true);
        return;
      }

      setState(() {
        _error = "Gagal menambah pemain.";
        _submitting = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: red, width: 2),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 8, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Tambah Pemain Baru",
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: _submitting ? null : () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Lengkapi data pemain aktif timnas Indonesia",
                  style: TextStyle(color: black),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 2, color: red),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Nama", style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _namaC,
                        decoration: _dec("Masukkan nama pemain"),
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? "Nama wajib diisi." : null,
                      ),
                      const SizedBox(height: 16),
                      const Text("Posisi", style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _posisi,
                        decoration: _dec("Pilih posisi"),
                        items: const [
                          DropdownMenuItem(value: "GK", child: Text("Goalkeeper")),
                          DropdownMenuItem(value: "DF", child: Text("Defender")),
                          DropdownMenuItem(value: "MF", child: Text("Midfielder")),
                          DropdownMenuItem(value: "FW", child: Text("Forward")),
                        ],
                        onChanged: _submitting ? null : (v) => setState(() => _posisi = v),
                        validator: (v) =>
                        (v == null || v.isEmpty) ? "Posisi wajib dipilih." : null,
                      ),
                      const SizedBox(height: 16),
                      const Text("Klub", style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _klubC,
                        decoration: _dec("Nama klub pemain"),
                        validator: (v) =>
                        (v == null || v.trim().isEmpty) ? "Klub wajib diisi." : null,
                      ),
                      const SizedBox(height: 16),
                      const Text("Umur", style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _umurC,
                        keyboardType: TextInputType.number,
                        decoration: _dec("Masukkan umur"),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Umur wajib diisi.";
                          final n = int.tryParse(v.trim());
                          if (n == null) return "Umur harus angka.";
                          if (n <= 0) return "Umur tidak valid.";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text("Market Value (€)", style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _marketC,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: _dec("Contoh: 2.50", helper: "Gunakan titik (.) untuk desimal"),
                        validator: _validateMarketValue,
                      ),
                      const SizedBox(height: 16),
                      const Text("URL Foto", style: TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _fotoC,
                        keyboardType: TextInputType.url,
                        decoration: _dec("https://contoh.com/foto.jpg", helper: "Wajib URL (http/https)"),
                        validator: _validatePhotoUrl,
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
                      const SizedBox(height: 18),
                      const Divider(height: 1),
                      const SizedBox(height: 14),
                      Row(
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
                            onPressed: _submitting ? null : () => Navigator.pop(context, false),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(width: 14),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: red,
                              foregroundColor: white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _submitting ? null : _submit,
                            child: _submitting
                                ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: white),
                            )
                                : const Text(
                              "Tambah Pemain",
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
