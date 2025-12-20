import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:garuda_lounge_mobile/screens/menu.dart';

const Color red = Color(0xFFAA1515);     // Primary: #AA1515
const Color white = Color(0xFFFFFFFF);   // Secondary: #FFFFFF
const Color cream = Color(0xFFE7E3DD);  // Background/Surface: #E7E3DD
const Color black = Color(0xFF111111);
const Color gray = Color(0xFF374151);

class MerchFormPage extends StatefulWidget {
  const MerchFormPage({super.key});

  @override
  State<MerchFormPage> createState() => _MerchFormPageState();
}

class _MerchFormPageState extends State<MerchFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _price = 0;
  String _description = "";
  String _thumbnail = "";
  String _category = "Jersey";
  String _productLink = "";

  final List<String> _categories = [
    'Jersey',
    'Shoes',
    'Ball',
    'GK Gloves',
    'Jacket',
    'Scarf',
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Tambah Product',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: white,
        foregroundColor: red,
      ),
      drawer: LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==== NAME ====
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Nama Merchandise",
                    labelText: "Nama Merchandise",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama merch tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // ==== PRICE ====
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Harga (IDR)",
                    labelText: "Harga (IDR)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _price = int.tryParse(value) ?? 0;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harga tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Harga harus berupa angka!";
                    }
                    if (int.parse(value) <= 0) {
                      return "Harga harus lebih besar dari nol!";
                    }
                    return null;
                  },
                ),
              ),
              // ==== DESCRIPTION ====
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Deskripsi Merchandise",
                    labelText: "Deskripsi Merchandise",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                  ),
                  onChanged: (value) => _description = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi tidak boleh kosong";
                    } 
                    return null;
                  },
                ), 
              ),
              // ==== CATEGORY ====
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _category,
                  items: _categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ),
                      )
                      .toList(),
                  onChanged: (newValue) =>
                      setState(() => _category = newValue!),
                ),
              ),
              // ==== URL THUMBNAIL ====
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "URL Thumbnail",
                    labelText: "URL Thumbnail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _thumbnail = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "URL wajib diisi!";
                    if (value != null && value.isNotEmpty) {
                      final regex = RegExp(r'^https?:\/\/.*\.(jpg|jpeg|png)$');
                      if (!regex.hasMatch(value)) {
                        return "Masukkan URL yang valid (berakhiran dengan .jpg, .png, atau .jpeg)";
                      }
                      return null;
                    }
                  },
                ),
              ),
              // ==== URL PRODUK ====
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "URL Produk",
                    labelText: "URL Produk",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _productLink = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "URL wajib diisi!";
                    return null;
                  },
                ),
              ),
              // ==== TOMBOL SIMPAN ====
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Tampilkan pop-up
                        final response = await request.postJson(
                          "http://localhost:8000/merchandise/create-flutter/",
                          jsonEncode({
                            "name": _name,
                            "description": _description,
                            "price": _price,
                            "thumbnail": _thumbnail,
                            "category": _category,
                            "product_link": _productLink
                          }),
                        );
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Merch successfully saved!"),
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
          ),
        ),
      ),
    );
  }
}