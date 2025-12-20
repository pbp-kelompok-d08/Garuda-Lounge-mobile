import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:garuda_lounge_mobile/screens/menu.dart';
import 'package:garuda_lounge_mobile/screens/news_entry_list.dart';
import 'package:garuda_lounge_mobile/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

const Color red = Color(0xFFAA1515);     // Primary: #AA1515
const Color white = Color(0xFFFFFFFF);   // Secondary: #FFFFFF
const Color cream = Color(0xFFE7E3DD);   // Background/Surface: #E7E3DD
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
        onTap: () async {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!")),
            );

          if (item.name == "Baca Berita Menarik") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewsEntryListPage()),
            );

          } else if (item.name == "Koleksi Merchandise") {
            // TODO: Navigasi ke halaman Merchandise

          } else if (item.name == "Jadwal Pertandingan") {
            // TODO: Navigasi ke halaman Match

          } else if (item.name == "Daftar Pemain Aktif") {
            // TODO: Navigasi ke halaman Pemain Aktif

          } else if (item.name == "Galeri Pemain Legend") {
            // TODO: Navigasi ke halaman Pemain Legend

          } else if (item.name == "Logout") {
            // ✅ Auto base URL:
            // Web/Chrome: localhost
            // Android Emulator: 10.0.2.2
            final baseUrl = kIsWeb ? "http://localhost:8000" : "http://10.0.2.2:8000";

            try {
              final response = await request.logout("$baseUrl/auth/logout/");
              debugPrint("LOGOUT RESPONSE: $response");

              if (!context.mounted) return;

              final message =
                  response["message"]?.toString() ?? "Logout response empty";
              final status = response["status"] == true;

              if (status) {
                final uname = response["username"]?.toString() ?? "";
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$message See you again, $uname.")),
                );

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Logout gagal: $message")),
                );
              }
            } catch (e) {
              debugPrint("LOGOUT ERROR: $e");
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Logout error: $e")),
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
                Icon(item.icon, color: white, size: 30.0),
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
