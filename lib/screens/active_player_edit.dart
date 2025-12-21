import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/player_entry.dart';

class EditPlayerForm extends StatefulWidget {
  final PlayerEntry player;
  final String baseUrl;

  const EditPlayerForm({
    super.key,
    required this.player,
    this.baseUrl = "http://localhost:8000",
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

    setState(() => _isSubmitting = true);

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

      // pbp_django_auth kadang balikin Map atau dynamic
      if (res is Map && res["status"] == "success") {
        Navigator.pop(context, true);
        return;
      }

      // kalau error dari backend: {"status":"error","errors":{...}} atau {"message":...}
      String msg = "Gagal update pemain";
      if (res is Map) {
        if (res["message"] != null) msg = res["message"].toString();
        if (res["errors"] is Map) {
          final errs = (res["errors"] as Map).values.map((e) => e.toString()).toList();
          if (errs.isNotEmpty) msg = errs.join("\n");
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFAA1515);
    const white = Colors.white;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Edit Pemain",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: red),
                        ),
                      ),
                      IconButton(
                        onPressed: _isSubmitting ? null : () => Navigator.pop(context, false),
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: "Nama",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => _validateRequiredText(v, "Nama"),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: _posisiKode,
                    decoration: const InputDecoration(
                      labelText: "Posisi",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: "GK", child: Text("Goalkeeper")),
                      DropdownMenuItem(value: "DF", child: Text("Defender")),
                      DropdownMenuItem(value: "MF", child: Text("Midfielder")),
                      DropdownMenuItem(value: "FW", child: Text("Forward")),
                    ],
                    onChanged: _isSubmitting ? null : (v) => setState(() => _posisiKode = v ?? "MF"),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _klubController,
                    decoration: const InputDecoration(
                      labelText: "Klub",
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => _validateRequiredText(v, "Klub"),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _umurController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Umur",
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateUmur,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _marketValueController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: "Market Value (€)",
                      hintText: "Contoh: 2.61",
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateMarketValue,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _fotoController,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(
                      labelText: "URL Foto (wajib)",
                      hintText: "https://....jpg",
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateUrl,
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: red,
                        foregroundColor: white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                          : const Text("Simpan Perubahan", style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
