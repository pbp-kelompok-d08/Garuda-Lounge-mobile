// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/match_entry.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart';
import 'package:garuda_lounge_mobile/screens/match_detail.dart';
import 'package:garuda_lounge_mobile/widgets/match_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:garuda_lounge_mobile/main.dart';
import 'package:garuda_lounge_mobile/screens/match_form.dart';
import 'dart:convert';


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

  String _currentFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Future<List<MatchEntry>> futureMatches = fetchMatch(request);
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

      drawer: const LeftDrawer(),
      
      
      body: Column ( 
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // tombol tambah match dan filter pertandingan
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) => const MatchFormPage(),
                    );

                    // jika result == true, artinya berhasil save, maka refresh halaman
                    if (result == true) {
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor: white,
                    side: BorderSide(color: black),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("+ Tambah Match", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                
                const SizedBox(width: 8),

                _buildFilterButton('Semua Match', 'all'),
                const SizedBox(width: 8),
                _buildFilterButton('Kualifikasi Pala Dunia', 'kualifikasi piala dunia'),
                const SizedBox(width: 8),
                _buildFilterButton('Piala Asia', 'piala asia'),
                const SizedBox(width: 8),
                _buildFilterButton('Piala ASEAN', 'piala asean'),
                const SizedBox(width: 8),
                _buildFilterButton('Persahabatan', 'pertandingan persahabatan'),
              ],
            ),
          ),

          Expanded( 
            child: FutureBuilder(
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
                    // filter data dari snapshot sebelum ditampilkan
                    List<MatchEntry> displayedMatches;
                    if (_currentFilter == 'all') {
                      displayedMatches = snapshot.data!;
                    } else {
                      displayedMatches = snapshot.data!.where((match) {
                        String matchType = match.jenisPertandingan.toLowerCase().trim();
                        String filterType = _currentFilter.toLowerCase().trim();
                        return matchType.contains(filterType);
                      }).toList();
                    }
                    if (displayedMatches.isEmpty) {
                      return Center(
                        child: Text(
                          'Tidak ada pertandingan "${titled(_currentFilter)}"',
                          style: TextStyle(color: red, fontSize: 20),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: displayedMatches.length,
                      itemBuilder: (_, index) {
                        final MatchEntry match = displayedMatches[index];
                        
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

                          onEditPressed: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (context) => MatchFormPage(
                                match: match, // buka modal form, terus kirim data match yang diklik sebagai parameter
                              ),
                            );

                            // refresh halaman ika berhasil tamabah atau edit match
                            if (result == true) {
                              setState(() {
                                
                              });
                            }
                          },

                          onDeletePressed: () {
                            // Panggil ini di dalam onDeletePressed
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // ambil lebar layar untuk logika responsive
                                final double screenWidth = MediaQuery.of(context).size.width;
                                
                                // tentukan padding dinamis (kecil di layar sempit, standar di layar lebar)
                                final double dynamicPadding = screenWidth < 400 ? 16.0 : 24.0; 
                                final double buttonPadding = screenWidth < 400 ? 10.0 : 14.0;

                                return Dialog(
                                  // atur margin dialog dari tepi layar
                                  insetPadding: const EdgeInsets.symmetric(horizontal: 16), 
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  backgroundColor: Colors.transparent, 
                                  elevation: 0,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 500), 
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: black, width: 2), 
                                        boxShadow: const [
                                          BoxShadow(
                                            color: black, 
                                            offset: Offset(6, 6), 
                                            blurRadius: 0,        
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView( 
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // header
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: dynamicPadding, 
                                                vertical: 16
                                              ),
                                              decoration: const BoxDecoration(
                                                color: cream, 
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                                border: Border(bottom: BorderSide(color: gray, width: 1)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded( // pakai Expanded agar teks tidak nabrak tombol close
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text(
                                                          "Hapus Pertandingan Ini?",
                                                          style: TextStyle(
                                                            fontSize: 25, 
                                                            fontWeight: FontWeight.w900, 
                                                            color: black
                                                          ),
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          "Setelah dihapus, tidak bisa dibatalkan.",
                                                          style: TextStyle(
                                                            fontSize: 16, 
                                                            color: black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.close, color: black),
                                                    onPressed: () => Navigator.pop(context),
                                                    padding: EdgeInsets.zero, 
                                                    constraints: const BoxConstraints(),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // jenis, tim, tanggal pertandingan
                                            Padding(
                                              padding: EdgeInsets.all(dynamicPadding),
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    "${titled(match.jenisPertandingan)}\n${match.timTuanRumah} vs ${match.timTamu}",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize: 20, 
                                                      fontWeight: FontWeight.bold,
                                                      color: black
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "Tanggal: ${match.tanggal}",
                                                    style: const TextStyle(color: gray, fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // footer: action buttons
                                           Container(
                                              padding: EdgeInsets.all(dynamicPadding),
                                              decoration: const BoxDecoration(
                                                color: cream, 
                                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)), 
                                                border: Border(top: BorderSide(color: black, width: 1)),
                                              ),
                                              child: Row(
                                                children: [
                                                  // tombol cancel
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      style: OutlinedButton.styleFrom(
                                                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                                                        side: const BorderSide(color: black, width: 2),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12)
                                                        ),
                                                        foregroundColor: black,
                                                        backgroundColor: Colors.white,
                                                      ),
                                                      child: const Text(
                                                        "Cancel", 
                                                        style: TextStyle(fontWeight: FontWeight.bold)
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(width: 12),

                                                  // tombol delete
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.symmetric(vertical: buttonPadding),
                                                        // hapus side border jika ingin style solid clean, atau biarkan jika sesuai desain
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                          side: const BorderSide(color: black, width: 2) 
                                                        ),
                                                        backgroundColor: red,
                                                        foregroundColor: Colors.white,
                                                        elevation: 0,
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.of(context).pop(); // tutup dialog dulu
                                                  
                                                        try {
                                                          // kirim request ke Django
                                                          final response = await request.postJson(
                                                            'http://localhost:8000/match/delete-match-flutter/${match.id}/', 
                                                            jsonEncode({"id": match.id}),
                                                          );

                                                          // cek status response, refresh kalau berhasil hapus
                                                          if (response['status'] == 'success') {
                                                            setState(() {
                                                            });
                                                            
                                                            if (context.mounted) {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                const SnackBar(content: Text("Match berhasil dihapus!")),
                                                              );
                                                            }
                                                          } else {
                                                            if (context.mounted) {
                                                              ScaffoldMessenger.of(context).showSnackBar(
                                                                const SnackBar(content: Text("Gagal menghapus match.")),
                                                              );
                                                            }
                                                          }
                                                        } catch (e) {
                                                          if (context.mounted) {
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text("Error: $e")),
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: const Text(
                                                        "Hapus", 
                                                        style: TextStyle(fontWeight: FontWeight.bold)
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );


                          //   showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       // ambil lebar layar untuk logika responsive
                          //       final double screenWidth = MediaQuery.of(context).size.width;
                                
                          //       // tentukan padding dinamis (kecil di layar sempit, standar di layar lebar)
                          //       final double dynamicPadding = screenWidth < 400 ? 16.0 : 24.0; 
                          //       final double buttonPadding = screenWidth < 400 ? 10.0 : 14.0;

                          //       return Dialog(
                          //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          //         elevation: 0,
                          //         backgroundColor: Colors.white, // atau transparent?
                          //         insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                          //         child: Container(
                          //           constraints: BoxConstraints(
                          //             maxHeight: MediaQuery.of(context).size.height * 0.9,
                          //           ),
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             borderRadius: BorderRadius.circular(16),
                          //             border: Border.all(color: black, width: 2),
                          //             boxShadow: const [
                          //               BoxShadow(color: black, offset: Offset(6, 6), blurRadius: 0),
                          //             ],
                          //           ),
                          //           child: Column(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               // header form
                          //               Container(
                          //                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          //                 decoration: const BoxDecoration(
                          //                   color: cream,
                          //                   borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                          //                   border: Border(bottom: BorderSide(color: gray, width: 1)),
                          //                 ),
                          //                 child: Row(
                          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     const Column(
                          //                       crossAxisAlignment: CrossAxisAlignment.start,
                          //                       children: [
                          //                         Text(
                          //                           "Hapus Match Ini?",
                          //                           style: TextStyle(
                          //                               fontSize: 18, fontWeight: FontWeight.w900, color: black),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                     IconButton(
                          //                       icon: const Icon(Icons.close, color: black),
                          //                       onPressed: () => Navigator.pop(context),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),

                          //               const SizedBox(height: 16),

                          //               Row(
                          //                 children: [
                          //                   Expanded(
                          //                     child: OutlinedButton(
                          //                       onPressed: () => Navigator.pop(context),
                          //                       style: OutlinedButton.styleFrom(
                          //                         padding: const EdgeInsets.symmetric(vertical: 14),
                          //                         side: const BorderSide(color: black, width: 2),
                          //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          //                         foregroundColor: black,
                          //                         backgroundColor: white,
                          //                       ),
                          //                       child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
                          //                     ),
                          //                   ),

                          //                   const SizedBox(width: 12),

                          //                   Expanded(
                          //                     child: OutlinedButton(
                          //                       style: OutlinedButton.styleFrom(
                          //                         padding: const EdgeInsets.symmetric(vertical: 14),
                          //                         side: const BorderSide(color: black, width: 2),
                          //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          //                         foregroundColor: white,
                          //                         backgroundColor: red,
                          //                       ),
                          //                       onPressed: () async {
                          //                       Navigator.of(context).pop(); // tutup dialog dulu
                                                
                          //                       try {
                          //                         // kirim request ke Django
                          //                         final response = await request.postJson(
                          //                           'http://localhost:8000/match/delete-match-flutter/${match.id}/', 
                          //                           jsonEncode({"id": match.id}),
                          //                         );

                          //                         // cek status response, refresh kalau berhasil hapus
                          //                         if (response['status'] == 'success') {
                          //                           setState(() {
                          //                           });
                                                    
                          //                           if (context.mounted) {
                          //                             ScaffoldMessenger.of(context).showSnackBar(
                          //                               const SnackBar(content: Text("Match berhasil dihapus!")),
                          //                             );
                          //                           }
                          //                         } else {
                          //                           if (context.mounted) {
                          //                             ScaffoldMessenger.of(context).showSnackBar(
                          //                               const SnackBar(content: Text("Gagal menghapus match.")),
                          //                             );
                          //                           }
                          //                         }
                          //                       } catch (e) {
                          //                         if (context.mounted) {
                          //                           ScaffoldMessenger.of(context).showSnackBar(
                          //                             SnackBar(content: Text("Error: $e")),
                          //                           );
                          //                         }
                          //                       }
                          //                     },
                          //                     child: const Text("Delete", style: TextStyle(color: white, fontWeight: FontWeight.bold)),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //               const SizedBox(height: 16),
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   );
                          },
                        );
                      }
                    );
                  }
                }
              },
            ),
          ),
        ]
      ),
    );
  }

  // fungsi helper tombol filter pertandingan
  Widget _buildFilterButton(String label, String filterValue) {
    bool isActive = _currentFilter == filterValue;
    return ElevatedButton(
      onPressed: () {
        // update state filter saat tombol ditekan 
        // ini memicu rebuild -> FutureBuilder jalan lagi -> Filter diterapkan
        setState(() {
          _currentFilter = filterValue;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? red : white,
        foregroundColor: isActive ? white : red,
        side: BorderSide(color: isActive ? black : red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    );
  }
}