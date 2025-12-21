import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/screens/menu.dart';
import 'package:garuda_lounge_mobile/screens/match_entry_list.dart';
import 'package:garuda_lounge_mobile/screens/news_entry_list.dart';
import 'package:garuda_lounge_mobile/screens/merch_entry_list.dart';
import 'package:garuda_lounge_mobile/main.dart';

String halamanDipilih = "Home";

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'GarudaLounge',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: red,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Semua tentang Timnas ada di sini!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14, // Sedikit dikecilkan agar proporsional
                    fontWeight: FontWeight.w600, // Medium weight terlihat lebih modern
                    color: gray,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(
              Icons.home,
              fontWeight: FontWeight.w600,
            ),
            title: const Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "Home",
            selectedColor: red,
            // Bagian redirection ke MyHomePage
            onTap: () {
              halamanDipilih = "Home";
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.newspaper,
              fontWeight: FontWeight.w600,
            ),
            title: const Text(
              'News',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "News",
            selectedColor: red,
            // Bagian redirection ke halaman News
            onTap: () {
              halamanDipilih = "News";
              /*
              TODO: Buatlah routing buat menampilkan daftar News
              */

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewsEntryListPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.shopping_bag,
              fontWeight: FontWeight.w600,
            ),
            title: const Text(
              'Merchandise',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "Merchandise",
            selectedColor: red,
            // Bagian redirection ke halaman Merchandise
            onTap: () {
              halamanDipilih = "Merchandise";
              /*
              TODO: Buatlah routing buat menampilkan daftar Merchandise
              */
              Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MerchEntryListPage(),
                    ));
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.sports_soccer,
              fontWeight: FontWeight.w600,
            ),
            title: const Text(
              'Match',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "Match",
            selectedColor: red,
            // Bagian redirection ke halaman match
            onTap: () {
              halamanDipilih = "Match";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchEntryListPage(),
                )
              );
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.person,
              fontWeight: FontWeight.w600,
            ),
            title: const Text(
              'Pemain Aktif',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "Pemain Aktif",
            selectedColor: red,
            // Bagian redirection ke halaman Pemain Aktif
            onTap: () {
              halamanDipilih = "Pemain Aktif";
              /*
              TODO: Buatlah routing buat menampilkan daftar Pemain Aktif
              */
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.person_outline_outlined,
              fontWeight: FontWeight.w600,
            ),
            title: const Text(
              'Pemain Legend',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "Pemain Legend",
            selectedColor: red,
            // Bagian redirection ke halaman Pemain Legend
            onTap: () {
              halamanDipilih = "Pemain Legend";
              /*
              TODO: Buatlah routing buat menampilkan daftar Pemain Legend
              */
            },
          ),
        ],
      ),
    );
  }
}
