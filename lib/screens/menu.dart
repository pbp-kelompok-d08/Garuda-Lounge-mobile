import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/widgets/homepage_card.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart';
import 'package:garuda_lounge_mobile/main.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final List<ItemHomepage> items = [
    ItemHomepage("Riwayat Pertandingan"), 
    ItemHomepage("Daftar Pemain Aktif"),
    ItemHomepage("Koleksi Merchandise"),
    ItemHomepage("Baca Berita Menarik"),
    ItemHomepage("Galeri Pemain Legend"),
  ];

  @override
  Widget build(BuildContext context) {
    halamanDipilih = "Home"; 

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Image.asset(
              'lib/assets/garudalounge.png', 
              height: 30, 
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 12), 

            const Text(
              'GarudaLounge',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: red, 
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),

          
      
      drawer: const LeftDrawer(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Text(
                        'GarudaLounge',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: red,
                        ),
                      ),
                    ),

                    Column(
                      children: items.map((ItemHomepage item) {
                        return ItemCard(item);
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              content, 
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;

  ItemHomepage(this.name);
}
