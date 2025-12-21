import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:garuda_lounge_mobile/screens/menu.dart';
import 'package:garuda_lounge_mobile/screens/match_entry_list.dart';
import 'package:garuda_lounge_mobile/screens/news_entry_list.dart';
import 'package:garuda_lounge_mobile/screens/merch_entry_list.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart'; 
import 'package:garuda_lounge_mobile/main.dart';
import 'package:garuda_lounge_mobile/screens/active_players_page.dart';
import 'package:garuda_lounge_mobile/screens/legend_page.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  // Fungsi helper untuk navigasi agar kode lebih rapi
  void _handleNavigation(BuildContext context) {
    if (item.name == "Baca Berita Menarik") {
      halamanDipilih = "News"; 
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewsEntryListPage()),
      );
    } else if (item.name == "Koleksi Merchandise") {
      halamanDipilih = "Merchandise";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MerchEntryListPage()),
      );
    } else if (item.name == "Riwayat Pertandingan") {
      halamanDipilih = "Match";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MatchEntryListPage()),
      );
    } else if (item.name == "Daftar Pemain Aktif") {
      halamanDipilih = "Pemain Aktif";
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ActivePlayersPage()),
      );
    } else if (item.name == "Galeri Pemain Legend") {
      halamanDipilih = "Pemain Legend";
      Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LegendPlayersPage()),
              );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), 
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: red, // Border warna merah
            width: 2.0,
          ),
          boxShadow: [
             BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ]
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text("Kamu telah menekan tombol ${item.name}!")));
              _handleNavigation(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  
                  ElevatedButton(
                    onPressed: () {
                      _handleNavigation(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      "Lihat",
                      style: TextStyle(fontWeight: FontWeight.bold),
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