import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:garuda_lounge_mobile/main.dart';
import 'package:garuda_lounge_mobile/models/merch_entry.dart';

class MerchFormPage extends StatefulWidget {
  final MerchEntry? merch;
  const MerchFormPage({super.key, this.merch});

  @override
  State<MerchFormPage> createState() => _MerchFormPageState();
}

class _MerchFormPageState extends State<MerchFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  int _price = 0;
  String _description = "";
  String _thumbnail = "";
  String _category = "jersey";
  String _productLink = "";

  final List<String> _categories = [
    'jersey',
    'shoes',
    'ball',
    'gk gloves',
    'jacket',
    'scarf',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.merch != null) {
      _name = widget.merch!.name;
      _price = widget.merch!.price;
      _description = widget.merch!.description;
      _thumbnail = widget.merch!.thumbnail;
      _category = widget.merch!.category;
      _productLink = widget.merch!.productLink;
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
                      if (widget.merch == null) ... [
                        const Text("Tambah Merch Baru", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: black),),
                        const Text("Masukkan Detail Merchandise",style: TextStyle(fontSize: 16, color: black)),
                      ]
                      else ... [
                        const Text("Edit Detail Merch", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: black),),
                        const Text("Perbarui Detail Merchandise Ini",style: TextStyle(fontSize: 16, color: black)),
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
                      // ==== NAME ====
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _name,
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
                          initialValue: _price.toString(),
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
                          initialValue: _description,
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
                          items: _categories
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ),
                              )
                              .toList(),
                          initialValue: _category,
                          decoration: InputDecoration(
                            labelText: "Kategori",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (newValue) =>
                              setState(() => _category = newValue!),
                        ),
                      ),
                      // ==== URL THUMBNAIL ====
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: _thumbnail,
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
                          initialValue: _productLink,
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

  Future<void> _submitData(CookieRequest request) async {
    try {
      String url;
      if (widget.merch == null) {
        url = "https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id/merchandise/create-flutter/";
      } else {
        url = "https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id/merchandise/edit-flutter/${widget.merch!.id}/";
      }
      final response = await request.postJson(
        url, 
        jsonEncode({
          "name": _name,
          "description": _description,
          "price": _price,
          "thumbnail": _thumbnail,
          "category": _category,
          "product_link": _productLink
        }),
      );

      if (mounted) {
        if (response['status'] == 'success') {
          // tutup modal dan kirim sinyal sukses
          Navigator.pop(context, true); 
          widget.merch == null 
            ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Merchandise berhasil ditambahkan!"), backgroundColor: Colors.green))
            :ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Merchandise berhasil diperbarui!"), backgroundColor: Colors.green));
          
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