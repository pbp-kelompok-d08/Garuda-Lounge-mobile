import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/screens/menu.dart';
import 'package:garuda_lounge_mobile/screens/match_entry_list.dart';
import 'package:garuda_lounge_mobile/screens/news_entry_list.dart';
import 'package:garuda_lounge_mobile/screens/merch_entry_list.dart';
import 'package:garuda_lounge_mobile/screens/login.dart'; 
import 'package:garuda_lounge_mobile/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart'; 
import 'package:garuda_lounge_mobile/provider/user_provider.dart'; 
import 'package:garuda_lounge_mobile/screens/active_players_page.dart';
import 'package:garuda_lounge_mobile/screens/legend_page.dart';

String halamanDipilih = "Home";

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>(); // request untuk logout
    final userProvider = context.read<UserProvider>(); // hapus value isStaff saat logout

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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: gray,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home, fontWeight: FontWeight.w600),
            title: const Text('Home', style: TextStyle(fontWeight: FontWeight.w600)),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "Home",
            selectedColor: red,
            onTap: () {
              halamanDipilih = "Home";
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.newspaper, fontWeight: FontWeight.w600),
            title: const Text('News', style: TextStyle(fontWeight: FontWeight.w600)),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "News",
            selectedColor: red,
            onTap: () {
              halamanDipilih = "News";
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NewsEntryListPage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.shopping_bag, fontWeight: FontWeight.w600),
            title: const Text('Merchandise', style: TextStyle(fontWeight: FontWeight.w600)),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "Merchandise",
            selectedColor: red,
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
            leading: const Icon(Icons.sports_soccer, fontWeight: FontWeight.w600),
            title: const Text('Match', style: TextStyle(fontWeight: FontWeight.w600)),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "Match",
            selectedColor: red,
            onTap: () {
              halamanDipilih = "Match";
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MatchEntryListPage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person, fontWeight: FontWeight.w600),
            title: const Text('Pemain Aktif', style: TextStyle(fontWeight: FontWeight.w600)),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "Pemain Aktif",
            selectedColor: red,
            onTap: () {
              halamanDipilih = "Pemain Aktif";
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActivePlayersPage()),
              );
             
            },
          ),

          ListTile(
            leading: const Icon(Icons.person_outline_outlined, fontWeight: FontWeight.w600),
            title: const Text('Pemain Legend', style: TextStyle(fontWeight: FontWeight.w600)),
            iconColor: black,
            textColor: black,
            selected: halamanDipilih == "Pemain Legend",
            selectedColor: red,
            onTap: () {
              halamanDipilih = "Pemain Legend";
              // TODO: Navigasi Pemain Legend
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LegendPlayersPage()),
              );
             
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, fontWeight: FontWeight.w600),
            title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w600)),
            iconColor: black,
            textColor: black,
            onTap: () async {
              userProvider.logout();
              final response = await request.logout(
                  "https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id/auth/logout/");
              String message = response["message"];
              if (context.mounted) {
                if (response['status']) {
                  String uname = response["username"];
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message See you again, $uname."),
                  ));
                  // reset halaman ke Home saat logout agar pas login balik ke Home
                  halamanDipilih = "Home"; 
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}