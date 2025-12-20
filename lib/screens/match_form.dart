// ignore_for_file: prefer_final_fields, unused_field, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart';
import 'package:flutter/services.dart'; // untuk formatters
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:garuda_lounge_mobile/screens/menu.dart';
import 'package:garuda_lounge_mobile/main.dart';

class MatchFormPage extends StatefulWidget {
    const MatchFormPage({super.key});

    @override
    State<MatchFormPage> createState() => _MatchFormPage();
}

class _MatchFormPage extends State<MatchFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _jenis_pertandingan = "pertandingan persahabatan"; // default

  String _tim_tuan_rumah = "-";
  String _tim_tamu = "-";

  String _bendera_tuan_rumah = "-";
  String _bendera_tamu = "-";

  String _tanggal = "-";
  String _stadion = "-";

  int _skor_tuan_rumah = 0;
  int _skor_tamu = 0;

  String _pencetak_gol_tuan_rumah = "-";
  String _pencetak_gol_tamu = "-";

  String _starter_tuan_rumah = "-";
  String _starter_tamu = "-";

  String _pengganti_tuan_rumah = "-";
  String _pengganti_tamu = "-";

  String _manajer_tuan_rumah = "-";
  String _manajer_tamu = "-";

  String _highlight = "-";

  // Statistik
  int _penguasaan_bola_tuan_rumah = 0;
  int _penguasaan_bola_tamu = 0;

  int _tembakan_tuan_rumah = 0;
  int _tembakan_tamu = 0;

  int _on_target_tuan_rumah = 0;
  int _on_target_tamu = 0;

  int _akurasi_umpan_tuan_rumah = 0;
  int _akurasi_umpan_tamu = 0;

  int _pelanggaran_tuan_rumah = 0;
  int _pelanggaran_tamu = 0;

  int _kartu_kuning_tuan_rumah = 0;
  int _kartu_kuning_tamu = 0;

  int _kartu_merah_tuan_rumah = 0;
  int _kartu_merah_tamu = 0;
  
  int _offside_tuan_rumah = 0;
  int _offside_tamu = 0;

  int _corner_tuan_rumah = 0;
  int _corner_tamu = 0;

  final List<String> _jenis_pertandingans = [
    'kualifikasi piala dunia', 
    'pertandingan persahabatan', 
    'piala asean', 
    'piala asia',
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Tambah Pertandingan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: white,
        foregroundColor: red,
      ),

      drawer: LeftDrawer(),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              // === Jenis Pertandingan ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Jenis Pertandingan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _jenis_pertandingan,
                  items: _jenis_pertandingans
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(
                                cat[0].toUpperCase() + cat.substring(1)),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _jenis_pertandingan = newValue!;
                    });
                  },
                ),
              ),

              // === Tim Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Tim Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _tim_tuan_rumah = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Tim Tuan Rumah tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tim Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Tim Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _tim_tamu = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Nama Tim tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Bendera Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Diawali https dan diakhiri oleh png, jpg, jpeg, atau sejenisnya",
                    labelText: "URL Bendera Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _bendera_tuan_rumah = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "URL Bendera Tim tidak boleh kosong!";
                    }
                    if (value.startsWith("https") == false) {
                      return "URL Bendera Tim tidak valid";
                    }
                    if (value.length > 500) {
                      return "URL Bendera Tim terlalu panjang";
                    }
                    return null;
                  },
                ),
              ),

              // === Bendera Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Diawali https dan diakhiri oleh png, jpg, jpeg, atau sejenisnya",
                    labelText: "URL Bendera Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _bendera_tamu = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "URL Bendera Tim tidak boleh kosong!";
                    }
                    if (value.startsWith("https") == false) {
                      return "URL Bendera Tim tidak valid";
                    }
                    if (value.length > 500) {
                      return "URL Bendera Tim terlalu panjang";
                    }
                    return null;
                  },
                ),
              ),

              // === Tanggal Pertandingan ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "dd-mm-yyyy",
                    labelText: "Tanggal Pertandingan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _tanggal = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Tanggal Pertandingan tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Stadion ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Stadion",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _stadion = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Stadion Pertandingan tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // ==== Skor Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    hintText: "Skor Tuan Rumah",
                    labelText: "Skor Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _skor_tuan_rumah = int.parse(value!);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Skor Tidak Boleh Kosong!';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Masukkan Angka Yang Valid!';
                    }
                    if (int.tryParse(value)! < 0) { // jika tidak null, cek input harga negatif
                      return 'Skor Tidak Boleh Negatif!';
                    }
                    return null;
                  },
                ),
              ),

              // ==== Skor Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    hintText: "Skor Tamu",
                    labelText: "Skor Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _skor_tamu = int.parse(value!);
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Skor Tidak Boleh Kosong!';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Masukkan Angka Yang Valid!';
                    }
                    if (int.tryParse(value)! < 0) { // jika tidak null, cek input harga negatif
                      return 'Skor Tidak Boleh Negatif!';
                    }
                    return null;
                  },
                ),
              ),

              // === Pencetak Gol Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Antarpemain Dipisah Dengan Tanda `;`",
                    labelText: "Pencetak Gol Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _pencetak_gol_tuan_rumah = value!;
                    });
                  },
                ),
              ),

              // === Pencetak Gol Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Antarpemain Dipisah Dengan Tanda `;`",
                    labelText: "Pencetak Gol Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _pencetak_gol_tamu = value!;
                    });
                  },
                ),
              ),

              // === Starter Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Antarpemain Dipisah Dengan Tanda `;`",
                    labelText: "Starter Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _starter_tuan_rumah = value!;
                    });
                  },
                ),
              ),

              // === Starter Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Antarpemain Dipisah Dengan Tanda `;`",
                    labelText: "Starter Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _starter_tamu = value!;
                    });
                  },
                ),
              ),

              // === Pengganti Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Antarpemain Dipisah Dengan Tanda `;`",
                    labelText: "Pengganti Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _pengganti_tuan_rumah = value!;
                    });
                  },
                ),
              ),

              // === Pengganti Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Antarpemain Dipisah Dengan Tanda `;`",
                    labelText: "Pengganti Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _pengganti_tamu = value!;
                    });
                  },
                ),
              ),

              // === Manajer Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Manajer Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _manajer_tuan_rumah = value!;
                    });
                  },
                ),
              ),

              // === Manajer Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Manajer Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _manajer_tamu = value!;
                    });
                  },
                ),
              ),

              // === URL Highlight ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Diawali https",
                    labelText: "URL Highlight",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _highlight = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "URL Highlight tidak boleh kosong!";
                    }
                    if (value.startsWith("https") == false) {
                      return "URL Highlight tidak valid";
                    }
                    if (value.length > 500) {
                      return "URL Highlight terlalu panjang";
                    }
                    return null;
                  },
                ),
              ),

              // ==== Penguasaan Bola Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Penguasaan Bola Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _penguasaan_bola_tuan_rumah = int.parse(value!);
                    });
                  },
                ),
              ),
              
              // ==== Penguasaan Bola Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Penguasaan Bola Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _penguasaan_bola_tamu = int.parse(value!);
                    });
                  },
                ),
              ),

              // ==== Tembakan Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Tembakan Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _tembakan_tuan_rumah = int.parse(value!);
                    });
                  },
                ),
              ),
              
              // ==== Tembakan Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Tembakan Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _tembakan_tamu = int.parse(value!);
                    });
                  },
                ),
              ),

              // ==== On Target Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "On Target Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _on_target_tuan_rumah = int.parse(value!);
                    });
                  },
                ),
              ),
              
              // ==== On Target Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "On Target Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _on_target_tamu = int.parse(value!);
                    });
                  },
                ),
              ),

               // ==== Akurasi Umpan Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Akurasi Umpan Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _akurasi_umpan_tuan_rumah = int.parse(value!);
                    });
                  },
                ),
              ),
              
              // ==== Akurasi Umpan Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Akurasi Umpan Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _akurasi_umpan_tamu = int.parse(value!);
                    });
                  },
                ),
              ),

              // ==== Pelanggaran Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Pelanggaran Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _pelanggaran_tuan_rumah = int.parse(value!);
                    });
                  },
                ),
              ),
              
              // ==== Pelanggaran Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Pelanggaran Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _pelanggaran_tamu = int.parse(value!);
                    });
                  },
                ),
              ),

              // ==== Kartu Kuning Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Kartu Kuning Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _kartu_kuning_tuan_rumah = int.parse(value!);
                    });
                  },
                ),
              ),
              
              // ==== Kartu Kuning Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Kartu Kuning Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _kartu_kuning_tamu = int.parse(value!);
                    });
                  },
                ),
              ),

              // ==== Kartu Merah Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Kartu Merah Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _kartu_merah_tuan_rumah = int.parse(value!);
                    });
                  },
                ),
              ),
              
              // ==== Kartu Merah Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Kartu Merah Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _kartu_merah_tamu = int.parse(value!);
                    });
                  },
                ),
              ),

              // ==== Offside Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Offside Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _offside_tuan_rumah = int.parse(value!);
                    });
                  },
                ),
              ),
              
              // ==== Offside Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Offside Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _offside_tamu = int.parse(value!);
                    });
                  },
                ),
              ),

              // ==== Corner Tuan Rumah ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Corner Tuan Rumah",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _corner_tuan_rumah = int.parse(value!);
                    });
                  },
                ),
              ),
              
              // ==== Corner Tamu ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number, // Displays a numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allows only digits
                  ],
                  decoration: InputDecoration(
                    labelText: "Corner Tamu",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _corner_tamu = int.parse(value!);
                    });
                  },
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(red),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Replace the URL with your app's URL
                        // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
                        // If you using chrome,  use URL http://localhost:8000
                        
                        final response = await request.postJson(
                          "http://localhost:8000/create-match-flutter/",
                          jsonEncode({
                            "jenis_pertandingan": _jenis_pertandingan,
                            "tim_tuan_rumah": _tim_tuan_rumah,
                            "tim_tamu": _tim_tamu,
                            "bendera_tuan_rumah": _bendera_tuan_rumah,
                            "bendera_tamu": _bendera_tamu,
                            "tanggal": _tanggal,
                            "stadion": _stadion,
                            "skor_tuan_rumah": _skor_tuan_rumah,
                            "skor_tamu": _skor_tamu,
                            "pencetak_gol_tuan_rumah": _pencetak_gol_tuan_rumah,
                            "pencetak_gol_tamu": _pencetak_gol_tamu,
                            "starter_tuan_rumah": _starter_tuan_rumah,
                            "starter_tamu": _starter_tamu,
                            "pengganti_tuan_rumah": _pengganti_tuan_rumah,
                            "pengganti_tamu": _pengganti_tamu,
                            "manajer_tuan_rumah": _manajer_tuan_rumah,
                            "manajer_tamu": _manajer_tamu,
                            "highlight": _highlight,
                            "penguasaan_bola_tuan_rumah": _penguasaan_bola_tuan_rumah,
                            "penguasaan_bola_tamu": _penguasaan_bola_tamu,
                            "tembakan_tuan_rumah": _tembakan_tuan_rumah,
                            "tembakan_tamu": _tembakan_tamu,
                            "on_target_tuan_rumah": _on_target_tuan_rumah,
                            "on_target_tamu": _on_target_tamu,
                            "akurasi_umpan_tuan_rumah": _akurasi_umpan_tuan_rumah,
                            "akurasi_umpan_tamu": _akurasi_umpan_tamu,
                            "pelanggaran_tuan_rumah": _pelanggaran_tuan_rumah,
                            "pelanggaran_tamu": _pelanggaran_tamu,
                            "kartu_kuning_tuan_rumah": _kartu_kuning_tuan_rumah,
                            "kartu_kuning_tamu": _kartu_kuning_tamu,
                            "kartu_merah_tuan_rumah": _kartu_merah_tuan_rumah,
                            "kartu_merah_tamu": _kartu_merah_tamu,
                            "offside_tuan_rumah": _offside_tuan_rumah,
                            "offside_tamu": _offside_tamu,
                            "corner_tuan_rumah": _corner_tuan_rumah,
                            "corner_tamu": _corner_tamu,
                          }),
                        );
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Match successfully saved!"),
                            ));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Something went wrong, please try again."),
                            ));
                          }
                        }
                      
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Pertandingam Berhasil Disimpan!'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                  children: [
                                    Text('Jenis Pertandingan: $_jenis_pertandingan'),
                                    Text('Tim Tuan Rumah: $_tim_tuan_rumah'),
                                    Text('Tim Tamu:  $_tim_tamu'),
                                    Text('Bendera Tuan Rumah: $_bendera_tuan_rumah'),
                                    Text('Bendera Tamu:  $_bendera_tamu'),
                                    Text('Tanggal: $_tanggal'),
                                    Text('Stadion:  $_stadion'),
                                    Text('Skor Tuan Rumah: $_skor_tuan_rumah'),
                                    Text('Skor Tamu:  $_skor_tamu'),
                                    Text('Pencetak Gol Tuan Rumah: $_pencetak_gol_tuan_rumah'),
                                    Text('Pencetak Gol Tamu:  $_pencetak_gol_tamu'),
                                    Text('Starter Tuan Rumah: $_starter_tuan_rumah'),
                                    Text('Starter Tamu:  $_starter_tamu'),
                                    Text('Pengganti Tuan Rumah: $_pengganti_tuan_rumah'),
                                    Text('Pengganti Tamu:  $_pengganti_tamu'),
                                    Text('Manajer Tuan Rumah: $_manajer_tuan_rumah'),
                                    Text('Manajer Tamu:  $_manajer_tamu'),
                                    Text('Highlight: $_highlight'),


                                    Text('Pengauasaan Bola Tuan Rumah: $_penguasaan_bola_tuan_rumah'),
                                    Text('Pnguasaan Bola Tamu:  $_penguasaan_bola_tamu'),
                                    Text('Tembakan Tuan Rumah: $_tembakan_tuan_rumah'),
                                    Text('Tembakan Tamu:  $_tembakan_tamu'),
                                    Text('On Target Tuan Rumah: $_on_target_tuan_rumah'),
                                    Text('On Target Tamu:  $_on_target_tamu'),
                                    Text('Akurasi Umpan Tuan Rumah: $_akurasi_umpan_tuan_rumah'),
                                    Text('Akurasi Umpan Tamu:  $_akurasi_umpan_tamu'),
                                    Text('Pelanggaran Tuan Rumah: $_pelanggaran_tuan_rumah'),
                                    Text('Pelanggaran Tamu:  $_pelanggaran_tamu'),
                                    Text('Kartu Kuning Tuan Rumah: $_kartu_kuning_tuan_rumah'),
                                    Text('Kartu Kuning Tamu:  $_kartu_kuning_tamu'),
                                    Text('Kartu Merah Tuan Rumah: $_kartu_merah_tuan_rumah'),
                                    Text('Kartu Merah Tamu:  $_kartu_merah_tamu'),
                                    Text('Offside Tuan Rumah: $_offside_tuan_rumah'),
                                    Text('Offside Tamu:  $_offside_tamu'),
                                    Text('Corner Tuan Rumah: $_corner_tuan_rumah'),
                                    Text('Corner Tamu:  $_corner_tamu'),
                                  ],
                                ),
                              ),

                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}