import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../models/player.dart';
import '../widgets/left_drawer.dart';

class ActivePlayersPage extends StatefulWidget {
  const ActivePlayersPage({super.key});

  @override
  State<ActivePlayersPage> createState() => _ActivePlayersPageState();
}

class _ActivePlayersPageState extends State<ActivePlayersPage> {
  Future<List<Player>> fetchPlayers(CookieRequest request) async {
    final response = await request.get(
      "http://10.0.2.2:8000/profileaktif/json/",
    );

    final List<Player> players = [];
    for (var item in response) {
      players.add(Player.fromJson(item));
    }
    return players;
  }

  String buildPhotoUrl(String rawUrl) {
    if (rawUrl.isEmpty) {
      return "";
    }
    final encoded = Uri.encodeComponent(rawUrl);
    return "http://10.0.2.2:8000/profileaktif/proxy-image/?url=$encoded";
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pemain Aktif"),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Player>>(
        future: fetchPlayers(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Terjadi masalah: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Belum ada pemain aktif terdaftar"),
            );
          }

          final players = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              final photoUrl = buildPhotoUrl(player.foto);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: photoUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Image.network(
                      photoUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const CircleAvatar(
                          child: Icon(Icons.person),
                        );
                      },
                    ),
                  )
                      : const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(
                    player.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${player.posisi} • ${player.klub}",
                  ),
                  trailing: Text(
                    "${player.umur} th",
                  ),
                  onTap: () {
                    // nanti bisa diarahkan ke halaman detail pemain
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
