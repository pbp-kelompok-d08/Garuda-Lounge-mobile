import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/screens/menu.dart';
import 'package:garuda_lounge_mobile/screens/match_entry_list.dart';
import 'package:garuda_lounge_mobile/screens/login.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:garuda_lounge_mobile/screens/news_entry_list.dart';
import 'package:garuda_lounge_mobile/screens/active_players_page.dart';

const Color red = Color(0xFFAA1515);     // Primary: #AA1515
const Color white = Color(0xFFFFFFFF);   // Secondary: #FFFFFF
const Color cream = Color(0xFFE7E3DD);  // Background/Surface: #E7E3DD
const Color black = Color(0xFF111111);
const Color gray = Color(0xFF374151);

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(12),

      child: InkWell(
        // Aksi ketika kartu ditekan.
        onTap: () async {
          // Menampilkan pesan SnackBar saat kartu ditekan.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!"))
            );

          // Navigate ke page sesuai tombol
          if (item.name == "Baca Berita Menarik") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewsEntryListPage(),
              ),
            );

          } else if (item.name == "Koleksi Merchandise") {
            // TODO: Navigasi ke halaman Merchandise

          } else if (item.name == "Jadwal Pertandingan") {
            // Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute untuk halaman Match
            halamanDipilih = "Match";
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MatchEntryListPage()
              ),
            );
          } else if (item.name == "Tambah Pertandingan") {
            // ini nyoba doang 
            // Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute untuk halaman Match
            halamanDipilih = "Match";
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MatchEntryListPage()
              ),
            );
          } else if (item.name == "Daftar Pemain Aktif") {
            // TODO: Navigasi ke halaman Pemain Aktif
            halamanDipilih = "Daftar Pemain Aktif";
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ActivePlayersPage()
              ),
            );

          } else if (item.name == "Galeri Pemain Legend") {
            // TODO: Gunakan Navigator.push untuk melakukan navigasi ke MaterialPageRoute untuk halaman Player Legend
          } else if (item.name == "Logout") {
            // Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
            // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
            // If you using chrome,  use URL http://localhost:8000
            
            final response = await request.logout(
                "http://localhost:8000/auth/logout/");
            String message = response["message"];
            if (context.mounted) {
              if (response['status']) {
                  String uname = response["username"];
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$message See you again, $uname."),
                  ));
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
              } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                }
            }
          }
        },

        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
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
