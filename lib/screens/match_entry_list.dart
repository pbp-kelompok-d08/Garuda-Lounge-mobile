import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/match_entry.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart';
import 'package:garuda_lounge_mobile/screens/match_detail.dart';
import 'package:garuda_lounge_mobile/widgets/match_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class MatchEntryListPage extends StatefulWidget {
  const MatchEntryListPage({super.key});

  @override
  State<MatchEntryListPage> createState() => _MatchEntryListPageState();
}

class _MatchEntryListPageState extends State<MatchEntryListPage> {
  Future<List<MatchEntry>> fetchMatch(CookieRequest request) async {
    // Replace the URL with your app's URL and don't forget to add a trailing slash (/)!
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome,  use URL http://localhost:8000
    
    final response = await request.get('http://localhost:8000/match/json/');
    
    // Decode response to json format
    var data = response;
    
    // Convert json data to MatchEntry objects
    List<MatchEntry> listMatch = [];
    for (var d in data) {
      if (d != null) {
        listMatch.add(MatchEntry.fromJson(d));
      }
    }
    return listMatch;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Future<List<MatchEntry>> futureMatches = fetchMatch(request);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Match Entry List',
          style: TextStyle(
          color: red,
          fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),

      drawer: const LeftDrawer(),
      
      
      body: FutureBuilder(
        future: futureMatches,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Belum ada pertandingan di GarudaLounge.',
                    style: TextStyle(fontSize: 20, color: red),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final MatchEntry match = snapshot.data![index];
                  
                  return MatchEntryCard(
                    match: match,
                    
                    onTap: () {
                      // Navigate to match detail page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MatchDetailPage(
                            match: snapshot.data![index],
                          ),
                        ),
                      );
                    },

                    onEditPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute( // navigasi ke form edit
                      //     builder: (context) => MatchEditPage(match: match),
                      //   ),
                      // );
                      print("edit match");
                    },

                    onDeletePressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: white,
                            title:  const Text(
                              "Hapus Pertandingan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: red,
                              ),
                            ),
                            content: Text("Apakah kamu yakin ingin menghapus pertandingan:\n${titled(match.jenisPertandingan)} - ${match.timTuanRumah} vs ${match.timTamu} (${match.tanggal})?",
                                      style: TextStyle(color: black, fontWeight: FontWeight.normal)),
                            actions: [
                              TextButton( // jika pilih cancel
                                onPressed: () {
                                  Navigator.of(context).pop(); // tutup dialog (batal)
                                },
                                child: const Text("Cancel", style: TextStyle(color: gray),),
                              ),

                              TextButton( // jika pilih delete
                                onPressed: () async {
                                  Navigator.of(context).pop(); // tutup dialog dulu
                                  
                                  // TODO: panggil fungsi request delete ke server Django
                                  // await request.post('.../delete/${match.pk}/');
                                  
                                  // Jika berhasil, refresh halaman
                                  setState(() {
                                    // refresh FutureBuilder
                                    futureMatches = fetchMatch(request); 
                                  });
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Match deleted successfully")),
                                  );
                                },
                                child: const Text("Delete", style: TextStyle(color: red)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                }
              );
            }
          }
        },
      ),
    );
  }
}