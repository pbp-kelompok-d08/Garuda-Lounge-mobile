import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/legend_entry.dart';

const Color dsRed = Color(0xFFAA1515);
const Color dsWhite = Color(0xFFFFFFFF);
const Color dsCream = Color(0xFFE7E3DD);
const Color dsBlack = Color(0xFF111111);

class LegendPlayerForm extends StatefulWidget {
  final LegendEntry? legend; 
  const LegendPlayerForm({super.key, this.legend});

  @override
  State<LegendPlayerForm> createState() => _LegendPlayerFormState();
}

class _LegendPlayerFormState extends State<LegendPlayerForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameC, _clubC, _ageC, _photoC;
  String? _position;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: widget.legend?.name ?? "");
    _clubC = TextEditingController(text: widget.legend?.club ?? "");
    _ageC = TextEditingController(text: widget.legend?.age.toString() ?? "");
    _photoC = TextEditingController(text: widget.legend?.photoUrl ?? "");
    _position = widget.legend?.position;
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: dsRed),
      filled: true,
      fillColor: dsWhite,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: dsRed)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: dsRed, width: 2)),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _position == null) return;
    setState(() => _isSubmitting = true);

    final request = context.read<CookieRequest>();
    final payload = {
      "name": _nameC.text.trim(),
      "position": _position,
      "club": _clubC.text.trim(),
      "age": int.parse(_ageC.text.trim()),
      "photo_url": _photoC.text.trim(),
    };

    final String url = widget.legend == null 
        ? "http://127.0.0.1:8000/ProfileLegend/create-flutter/"
        : "http://127.0.0.1:8000/ProfileLegend/edit-flutter/${widget.legend!.id}/";

    final response = await request.postJson(url, jsonEncode(payload));

    if (response["status"] == "success") {
      if (mounted) Navigator.pop(context, true);
    } else {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: dsCream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: dsRed, width: 3)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.legend == null ? "TAMBAH LEGEND" : "EDIT LEGEND", 
                  style: const TextStyle(color: dsRed, fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              TextFormField(controller: _nameC, decoration: _dec("Nama Lengkap", Icons.person), validator: (v) => v!.isEmpty ? "Wajib diisi" : null),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _position,
                decoration: _dec("Posisi", Icons.sports_soccer),
                items: ["Kiper", "Bek", "Gelandang", "Penyerang"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _position = v),
              ),
              const SizedBox(height: 15),
              TextFormField(controller: _clubC, decoration: _dec("Klub", Icons.shield)),
              const SizedBox(height: 15),
              TextFormField(controller: _ageC, decoration: _dec("Umur", Icons.cake), keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              TextFormField(controller: _photoC, decoration: _dec("URL Foto", Icons.image)),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("BATAL")),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: dsRed),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting ? const CircularProgressIndicator(color: dsWhite) : const Text("SIMPAN", style: TextStyle(color: dsWhite)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}