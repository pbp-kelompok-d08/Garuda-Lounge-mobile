import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/widgets/homepage_card.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart';

const Color red = Color(0xFFAA1515);     // Primary: #AA1515
const Color white = Color(0xFFFFFFFF);   // Secondary: #FFFFFF
const Color cream = Color(0xFFE7E3DD);   // Background/Surface: #E7E3DD
const Color black = Color(0xFF111111);

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final List<ItemHomepage> items = [
    ItemHomepage("Baca Berita Menarik", Icons.newspaper),
    ItemHomepage("Koleksi Merchandise", Icons.shopping_bag),
    ItemHomepage("Jadwal Pertandingan", Icons.sports_soccer),
    ItemHomepage("Daftar Pemain Aktif", Icons.person),
    ItemHomepage("Galeri Pemain Legend", Icons.person_outline_outlined),
    ItemHomepage("Logout", Icons.logout), // ✅ Tambah logout
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GarudaLounge',
          style: TextStyle(
            color: red,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      drawer: LeftDrawer(),

      // ✅ FIX OVERFLOW: buat halaman bisa scroll
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  InfoCard(title: 'Judul 1', content: "teks 1"),
                  InfoCard(title: 'Judul 2', content: "teks 2"),
                  InfoCard(title: 'Judul 3', content: "teks 3"),
                ],
              ),

              const SizedBox(height: 16.0),

              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Selamat datang di GarudaLounge',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),

              // ✅ Grid di dalam scroll: shrinkWrap + matikan scroll grid
              GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,

                // Catatan: 5 ini cocok untuk web, kalau mau lebih rapi bisa 3
                crossAxisCount: 5,

                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                children: items.map((ItemHomepage item) {
                  return ItemCard(item);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: white,
      shadowColor: red,
      elevation: 2.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}
