import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/screens/menu.dart';
import 'package:garuda_lounge_mobile/screens/merch_form.dart';

const Color red = Color(0xFFAA1515);     // Primary: #AA1515
const Color white = Color(0xFFFFFFFF);   // Secondary: #FFFFFF
const Color cream = Color(0xFFE7E3DD);  // Background/Surface: #E7E3DD
const Color black = Color(0xFF111111);
const Color gray = Color(0xFF374151);

class ItemCard extends StatelessWidget {
  // Menampilkan kartu dengan ikon dan nama.

  final ItemHomepage item; 

  const ItemCard(this.item, {super.key}); 

  @override
  Widget build(BuildContext context) {
    return Material(
      // Menentukan warna latar belakang dari tema aplikasi.
      color: Theme.of(context).colorScheme.primary,
      // Membuat sudut kartu melengkung.
      borderRadius: BorderRadius.circular(12),

      child: InkWell(
        // Aksi ketika kartu ditekan.
        onTap: () {
          // Menampilkan pesan SnackBar saat kartu ditekan.
          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!"))
          );

          // Navigate ke route yang sesuai (tergantung jenis tombol)
          if (item.name == "Baca Berita Menarik") {
            // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute untuk halaman News
          } else if (item.name == "Koleksi Merchandise") {
            // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute untuk halaman Merch
            Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MerchFormPage(),
                    ));
          } else if (item.name == "Jadwal Pertandingan") {
            // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute untuk halaman Match
          } else if (item.name == "Daftar Pemain Aktif") {
            // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute untuk halaman Player Aktif
          } else if (item.name == "Galeri Pemain Legend") {
            // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute untuk halaman Player Legend
          }
        },
        // Container untuk menyimpan Icon dan Text
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              // Menyusun ikon dan teks di tengah kartu.
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}