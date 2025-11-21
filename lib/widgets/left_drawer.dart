import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/screens/menu.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
            color: Colors.blue,
            ),
            child: Column(
              children: [
                Text(
                  'GarudaLounge',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text("Semua tentang Timnas ada di sini!",
                textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),

          ListTile(
            leading: const Icon(Icons.post_add),
            title: const Text('News'),
            // Bagian redirection ke halaman News
            onTap: () {
              /*
              TODO: Buatlah routing buat menampilkan daftar News
              */
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.post_add),
            title: const Text('Merchandise'),
            // Bagian redirection ke halaman Merchandise
            onTap: () {
              /*
              TODO: Buatlah routing buat menampilkan daftar Merchandise
              */
            },
          ),

          ListTile(
            leading: const Icon(Icons.post_add),
            title: const Text('Match'),
            // Bagian redirection ke halaman match
            onTap: () {
              /*
              TODO: Buatlah routing buat menampilkan daftar match
              */
            },
          ),

          ListTile(
            leading: const Icon(Icons.post_add),
            title: const Text('Pemain Aktif'),
            // Bagian redirection ke halaman Pemain Aktif
            onTap: () {
              /*
              TODO: Buatlah routing buat menampilkan daftar Pemain Aktif
              */
            },
          ),

          ListTile(
            leading: const Icon(Icons.post_add),
            title: const Text('Pemain Legend'),
            // Bagian redirection ke halaman Pemain Legend
            onTap: () {
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