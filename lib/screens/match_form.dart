// ignore_for_file: prefer_final_fields, unused_field, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // untuk formatters
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:garuda_lounge_mobile/main.dart';
import 'package:garuda_lounge_mobile/models/match_entry.dart';

class MatchFormPage extends StatefulWidget {
  final MatchEntry? match;
  const MatchFormPage({super.key, this.match}); // untuk bedakan ini edit match yang duah ada atau nambah match baru

  @override
  State<MatchFormPage> createState() => _MatchFormPage();
}

class _MatchFormPage extends State<MatchFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _jenisPertandingan = "pertandingan persahabatan"; // default

  String _timTuanRumah = "";
  String _timTamu = "";

  String _benderaTuanRumah = "";
  String _benderaTamu = "";

  String _tanggal = "";
  String _stadion = "";

  int _skorTuanRumah = 0;
  int _skorTamu = 0;

  String _pencetakGolTuanRumah = "";
  String _pencetakGolTamu = "";

  String _starterTuanRumah = "";
  String _starterTamu = "";

  String _penggantiTuanRumah = "";
  String _penggantiTamu = "";

  String _manajerTuanRumah = "";
  String _manajerTamu = "";

  String _highlight = "";

  // Statistik
  int _penguasaanBolaTuanRumah = 0;
  int _penguasaanBolaTamu = 0;

  int _tembakanTuanRumah = 0;
  int _tembakanTamu = 0;

  int _onTargetTuanRumah = 0;
  int _onTargetTamu = 0;

  int _akurasiUmpanTuanRumah = 0;
  int _akurasiUmpanTamu = 0;

  int _pelanggaranTuanRumah = 0;
  int _pelanggaranTamu = 0;

  int _kartuKuningTuanRumah = 0;
  int _kartuKuningTamu = 0;

  int _kartuMerahTuanRumah = 0;
  int _kartuMerahTamu = 0;
  
  int _offsideTuanRumah = 0;
  int _offsideTamu = 0;

  int _cornerTuanRumah = 0;
  int _cornerTamu = 0;

  final List<String> _listJenisPertandingan = [
    'kualifikasi piala dunia', 
    'pertandingan persahabatan', 
    'piala asean', 
    'piala asia',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.match != null) { // jika mau edit, maka eidgetnya tidak null
      // isi dnegan data dat dari match yang mau di-edit
      _jenisPertandingan = widget.match!.jenisPertandingan;
      _timTuanRumah = widget.match!.timTuanRumah;
      _timTamu = widget.match!.timTamu;
      _benderaTuanRumah = widget.match!.benderaTuanRumah;
      _benderaTamu = widget.match!.benderaTamu;
      _tanggal = widget.match!.tanggal;
      _stadion = widget.match!.stadion;
      
      // janlup konversi string (dari model) ke int (ke state form ini)
      _skorTuanRumah = int.tryParse(widget.match!.skorTuanRumah) ?? 0;
      _skorTamu = int.tryParse(widget.match!.skorTamu) ?? 0;
      
      // mapping field yang string ke string
      _pencetakGolTuanRumah = widget.match!.pencetakGolTuanRumah;
      _pencetakGolTamu = widget.match!.pencetakGolTamu;
      _starterTuanRumah = widget.match!.starterTuanRumah;
      _starterTamu = widget.match!.starterTamu;
      _penggantiTuanRumah = widget.match!.penggantiTuanRumah;
      _penggantiTamu = widget.match!.penggantiTamu;
      _manajerTuanRumah = widget.match!.manajerTuanRumah;
      _manajerTamu = widget.match!.manajerTamu;
      _highlight = widget.match!.highlight;
      
      // statistik ini dikonversi juga dari string ke int
      _penguasaanBolaTuanRumah = int.tryParse(widget.match!.penguasaanBolaTuanRumah) ?? 0;
      _penguasaanBolaTamu = int.tryParse(widget.match!.penguasaanBolaTamu) ?? 0;
      _tembakanTuanRumah = int.tryParse(widget.match!.tembakanTuanRumah) ?? 0;
      _tembakanTamu = int.tryParse(widget.match!.tembakanTamu) ?? 0;
      _onTargetTuanRumah = int.tryParse(widget.match!.onTargetTuanRumah) ?? 0;
      _onTargetTamu = int.tryParse(widget.match!.onTargetTamu) ?? 0;
      _akurasiUmpanTuanRumah = int.tryParse(widget.match!.akurasiUmpanTuanRumah) ?? 0;
      _akurasiUmpanTamu = int.tryParse(widget.match!.akurasiUmpanTamu) ?? 0;
      _pelanggaranTuanRumah = int.tryParse(widget.match!.pelanggaranTuanRumah) ?? 0;
      _pelanggaranTamu = int.tryParse(widget.match!.pelanggaranTamu) ?? 0;
      _kartuKuningTuanRumah = int.tryParse(widget.match!.kartuKuningTuanRumah) ?? 0;
      _kartuKuningTamu = int.tryParse(widget.match!.kartuKuningTamu) ?? 0;
      _kartuMerahTuanRumah = int.tryParse(widget.match!.kartuMerahTuanRumah) ?? 0;
      _kartuMerahTamu = int.tryParse(widget.match!.kartuMerahTamu) ?? 0;
      _offsideTuanRumah = int.tryParse(widget.match!.offsideTuanRumah) ?? 0;
      _offsideTamu = int.tryParse(widget.match!.offsideTamu) ?? 0;
      _cornerTuanRumah = int.tryParse(widget.match!.cornerTuanRumah) ?? 0;
      _cornerTamu = int.tryParse(widget.match!.cornerTamu) ?? 0;
    
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: black, width: 2),
          boxShadow: const [
            BoxShadow(color: black, offset: Offset(6, 6), blurRadius: 0),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // header form
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                border: Border(bottom: BorderSide(color: gray, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.match == null) ... [
                        const Text("Tambah Match Baru", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: black),),
                        const Text("Masukkan Detail Pertandingan",style: TextStyle(fontSize: 16, color: black)),
                      ]
                      else ... [
                        const Text("Edit Detail Match", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: black),),
                        const Text("Perbarui Detail Pertandingan Ini",style: TextStyle(fontSize: 16, color: black)),
                      ]

                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // body form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Jenis Pertandingan ---
                      _buildLabel("Jenis Pertandingan"),
                      DropdownButtonFormField<String>(
                        initialValue: _jenisPertandingan,
                        value: _jenisPertandingan,
                        decoration: _inputDecoration(),
                        items: _listJenisPertandingan.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _jenisPertandingan = val!),
                      ),
                      const SizedBox(height: 16),

                      // --- Tim & Skor ---
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Tim Tuan Rumah"),
                                TextFormField(
                                  initialValue: _timTuanRumah,
                                  decoration: _inputDecoration(hint: "Nama Tim"),
                                  onChanged: (v) => _timTuanRumah = v,
                                  validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Skor"),
                                TextFormField(
                                  initialValue: _skorTuanRumah.toString(),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: _inputDecoration(),
                                  onChanged: (v) => _skorTuanRumah = int.tryParse(v) ?? 0,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return "Wajib diisi";
                                    if (int.tryParse(v)! < 0) return "Tidak boleh angka negatif"; 
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      _buildLabel("URL Bendera Tuan Rumah"),
                      TextFormField(
                        initialValue: _benderaTuanRumah,
                        maxLength: 500,
                        decoration: _inputDecoration(hint: "https://..."),
                        onChanged: (v) => _benderaTuanRumah = v,
                        validator: (v) {
                          if (v!.length > 500) return "Maksimal 500 karakter";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Tim Tamu"),
                                TextFormField(
                                  initialValue: _timTamu,
                                  decoration: _inputDecoration(hint: "Nama Tim"),
                                  onChanged: (v) => _timTamu = v,
                                  validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("Skor"),
                                TextFormField(
                                  initialValue: _skorTamu.toString(),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: _inputDecoration(),
                                  onChanged: (v) => _skorTamu = int.tryParse(v) ?? 0,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) return "Wajib diisi";
                                    if (int.tryParse(v)! < 0) return "Tidak boleh angka negatif"; 
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      _buildLabel("URL Bendera Tamu"),
                      TextFormField(
                        initialValue: _benderaTamu,
                        maxLength: 500,
                        decoration: _inputDecoration(hint: "https://..."),
                        onChanged: (v) => _benderaTamu = v,
                        validator: (v) {
                          if (v!.length > 500) return "Maksimal 500 karakter";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

          
                      _buildLabel("Tanggal (dd-mm-yyyy)"),
                      TextFormField(
                        initialValue: _tanggal,
                        decoration: _inputDecoration(hint: "Contoh: 21-12-2025"),
                        onChanged: (v) => _tanggal = v,
                        validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildLabel("Stadion"),
                      TextFormField(
                        initialValue: _stadion,
                        decoration: _inputDecoration(),
                        onChanged: (v) => _stadion = v,
                        validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("URL Highlight"),
                      TextFormField(
                        initialValue: _highlight,
                        maxLength: 500,
                        decoration: _inputDecoration(hint: "https://..."),
                        onChanged: (v) => _highlight = v,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          if (v.length > 500) return "Maksimal 500 karakter";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Pencetak Gol Tuan Rumah"),
                      TextFormField(
                        initialValue: _pencetakGolTuanRumah,
                        decoration: _inputDecoration(hint: "pemain1;pemain2;..."),
                        onChanged: (v) => _pencetakGolTuanRumah = v,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Pencetak Gol Tamu"),
                      TextFormField(
                        initialValue: _pencetakGolTamu,
                        decoration: _inputDecoration(hint: "pemain1;pemain2;..."),
                        onChanged: (v) => _pencetakGolTamu = v,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Starter Tuan Rumah"),
                      TextFormField(
                        initialValue: _starterTuanRumah,
                        decoration: _inputDecoration(hint: "pemain1;pemain2;..."),
                        onChanged: (v) => _starterTuanRumah = v,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Starter Tamu"),
                      TextFormField(
                        initialValue: _starterTamu,
                        decoration: _inputDecoration(hint: "pemain1;pemain2;..."),
                        onChanged: (v) => _starterTamu = v,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Pengganti Tuan Rumah"),
                      TextFormField(
                        initialValue: _penggantiTuanRumah,
                        decoration: _inputDecoration(hint: "pemain1;pemain2;..."),
                        onChanged: (v) => _penggantiTuanRumah = v,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Pengganti Tamu"),
                      TextFormField(
                        initialValue: _penggantiTamu,
                        decoration: _inputDecoration(hint: "pemain1;pemain2;..."),
                        onChanged: (v) => _penggantiTamu = v,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Manajer Tuan Rumah"),
                      TextFormField(
                        initialValue: _manajerTuanRumah,
                        decoration: _inputDecoration(),
                        onChanged: (v) => _manajerTuanRumah = v,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Manajer Tamu"),
                      TextFormField(
                        initialValue: _manajerTamu,
                        decoration: _inputDecoration(),
                        onChanged: (v) => _manajerTamu = v,
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Penguasaan Bola Tuan Rumah"),
                      TextFormField(
                        initialValue: _penguasaanBolaTuanRumah.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _penguasaanBolaTuanRumah = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Penguasaan Bola Tamu"),
                      TextFormField(
                        initialValue: _penguasaanBolaTamu.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _penguasaanBolaTamu = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Tembakan Tuan Rumah"),
                      TextFormField(
                        initialValue: _tembakanTuanRumah.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _tembakanTuanRumah = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Tembakan Tamu"),
                      TextFormField(
                        initialValue: _tembakanTamu.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _tembakanTamu = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("On Target Tuan Rumah"),
                      TextFormField(
                        initialValue: _onTargetTuanRumah.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _onTargetTuanRumah = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("On Target Tamu"),
                      TextFormField(
                        initialValue: _onTargetTamu.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _onTargetTamu = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Akurasi Umpan Tuan Rumah"),
                      TextFormField(
                        initialValue: _akurasiUmpanTuanRumah.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _akurasiUmpanTuanRumah = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Akurasi umpan Tamu"),
                      TextFormField(
                        initialValue: _akurasiUmpanTamu.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _akurasiUmpanTamu = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Pelanggaran Tuan Rumah"),
                      TextFormField(
                        initialValue: _pelanggaranTuanRumah.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _pelanggaranTuanRumah = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Pelanggaran Tamu"),
                      TextFormField(
                        initialValue: _pelanggaranTamu.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _pelanggaranTamu = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Kartu Kuning Tuan Rumah"),
                      TextFormField(
                        initialValue: _kartuKuningTuanRumah.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _kartuKuningTuanRumah = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Kartu Kuning Tamu"),
                      TextFormField(
                        initialValue: _kartuKuningTamu.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _kartuKuningTamu = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Kartu Merah Tuan Rumah"),
                      TextFormField(
                        initialValue: _kartuMerahTuanRumah.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _kartuMerahTuanRumah = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Kartu Merah Tamu"),
                      TextFormField(
                        initialValue: _kartuMerahTamu.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _kartuMerahTamu = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Offside Tuan Rumah"),
                      TextFormField(
                        initialValue: _offsideTuanRumah.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _offsideTuanRumah = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Offside Tamu"),
                      TextFormField(
                        initialValue: _offsideTamu.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _offsideTamu = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Corner Tuan Rumah"),
                      TextFormField(
                        initialValue: _cornerTuanRumah.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _cornerTuanRumah = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      _buildLabel("Corner Tamu"),
                      TextFormField(
                        initialValue: _cornerTamu.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: _inputDecoration(),
                        onChanged: (v) => _cornerTamu = int.tryParse(v) ?? 0,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "Wajib diisi";
                          final number = int.tryParse(v);
                          if (number == null) return "Harus angka";
                          if (number < 0) return "Tidak boleh negatif";
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                    ],
                  ),
                ),
              ),
            ),

            // footer: actions buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: cream,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
                border: Border(top: BorderSide(color: Colors.grey, width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: black, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        foregroundColor: black,
                        backgroundColor: Colors.white,
                      ),
                      child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _submitData(request);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: black, width: 2)
                        ),
                        elevation: 0,
                      ),
                      child: const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // helper widgets
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: red)),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: red, width: 2),
      ),
    );
  }

  Future<void> _submitData(CookieRequest request) async {
    try {
      String url;
      if (widget.match == null) {
        url = "https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id/match/create-match-flutter/";
      } else {
        url = "https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id/match/edit-match-flutter/${widget.match!.id}/";
      }
      final response = await request.postJson(
        url, 
        jsonEncode({
          "jenis_pertandingan": _jenisPertandingan,
          "tim_tuan_rumah": _timTuanRumah,
          "tim_tamu": _timTamu,
          "bendera_tuan_rumah": _benderaTuanRumah,
          "bendera_tamu": _benderaTamu,
          "tanggal": _tanggal,
          "stadion": _stadion,
          "skor_tuan_rumah": _skorTuanRumah,
          "skor_tamu": _skorTamu,
          "highlight": _highlight,

          "pencetak_gol_tuan_rumah": _pencetakGolTuanRumah,
          "pencetak_gol_tamu": _pencetakGolTamu,
          "starter_tuan_rumah": _starterTuanRumah,
          "starter_tamu": _starterTamu,
          "pengganti_tuan_rumah": _penggantiTuanRumah,
          "pengganti_tamu": _penggantiTamu,
          "manajer_tuan_rumah": _manajerTuanRumah,
          "manajer_tamu": _manajerTamu,

          "penguasaan_bola_tuan_rumah": _penguasaanBolaTuanRumah,
          "penguasaan_bola_tamu": _penguasaanBolaTamu,
          "tembakan_tuan_rumah": _tembakanTuanRumah,
          "tembakan_tamu": _tembakanTamu,
          "on_target_tuan_rumah": _onTargetTuanRumah,
          "on_target_tamu": _onTargetTamu,
          "akurasi_umpan_tuan_rumah": _akurasiUmpanTuanRumah,
          "akurasi_umpan_tamu": _akurasiUmpanTamu,
          "pelanggaran_tuan_rumah": _pelanggaranTuanRumah,
          "pelanggaran_tamu": _pelanggaranTamu,
          "kartu_kuning_tuan_rumah": _kartuKuningTuanRumah,
          "kartu_kuning_tamu": _kartuKuningTamu,
          "kartu_merah_tuan_rumah": _kartuMerahTuanRumah,
          "kartu_merah_tamu": _kartuMerahTamu,
          "offside_tuan_rumah": _offsideTuanRumah,
          "offside_tamu": _offsideTamu,
          "corner_tuan_rumah": _cornerTuanRumah,
          "corner_tamu": _cornerTamu,
        }),
      );

      if (mounted) {
        if (response['status'] == 'success') {
          // tutup modal dan kirim sinyal sukses
          Navigator.pop(context, true); 
          widget.match == null 
            ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Match berhasil ditambahkan!"), backgroundColor: Colors.green))
            :ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Match berhasil diperbarui!"), backgroundColor: Colors.green));
          
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menyimpan, cek data kembali."), backgroundColor: Colors.red));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }
}