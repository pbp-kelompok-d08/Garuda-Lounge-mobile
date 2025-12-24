import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/merch_entry.dart';
import 'package:garuda_lounge_mobile/screens/merch_form.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart';
import 'package:garuda_lounge_mobile/screens/merch_detail.dart';
import 'package:garuda_lounge_mobile/widgets/merch_entry_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import 'package:garuda_lounge_mobile/provider/user_provider.dart';

class MerchEntryListPage extends StatefulWidget {
  const MerchEntryListPage({super.key});

  @override
  State<MerchEntryListPage> createState() => _MerchEntryListPageState();
}

class _MerchEntryListPageState extends State<MerchEntryListPage> {

  // kita mau fetch status user sekali saja saat halaman dibuka
  // pakai addPostFrameCallback karena kita butuh context provider
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       final request = context.read<CookieRequest>();
       final userProvider = context.read<UserProvider>();
       
       // ini tidak jalan kalau sudahpernah fetch
       userProvider.fetchUserStatus(request);
    });
  }

  Future<List<MerchEntry>> fetchMerch(CookieRequest request) async {
    // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
    // If you using chrome,  use URL http://localhost:8000
    
    final response = await request.get('https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id/merchandise/json/');
    
    // Decode response to json format
    var data = response;
    
    // Convert json data to MerchEntry objects
    List<MerchEntry> listMerch = [];
    for (var d in data) {
      if (d != null) {
        listMerch.add(MerchEntry.fromJson(d));
      }
    }
    return listMerch;
  }

  String _currentFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final userProvider = context.watch<UserProvider>(); 
    final isStaff = userProvider.isStaff; // ambil status user dari provider
    Future<List<MerchEntry>> futureMerch = fetchMerch(request);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GarudaLounge',
          style: TextStyle(
          color: Color(0xFFAA1515),
          fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),

      drawer: const LeftDrawer(),
      body: Column ( 
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // tombol tambah merch dan filter pertandingan
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                //TODO: hanya bisa diakses oleh admin
                if (isStaff) ...[
                  ElevatedButton(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => const MerchFormPage(),
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
                    child: const Text("+ Tambah Merch", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  
                  const SizedBox(width: 8),
                ],

                _buildFilterButton('Semua Merch', 'all'),
                const SizedBox(width: 8),
                _buildFilterButton('Jersey', 'jersey'),
                const SizedBox(width: 8),
                _buildFilterButton('Sepatu', 'shoes'),
                const SizedBox(width: 8),
                _buildFilterButton('Bola', 'ball'),
                const SizedBox(width: 8),
                _buildFilterButton('Sarung Tangan Kiper', 'gk gloves'),
                const SizedBox(width: 8),
                _buildFilterButton('Jaket', 'jacket'),
                const SizedBox(width: 8),
                _buildFilterButton('Syal', 'scarf'),
              ],
            ),
          ),

          Expanded( 
            child: FutureBuilder(
              future: futureMerch,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (!snapshot.hasData) {
                    return const Column(
                      children: [
                        Text(
                          'Belum ada merchandise di GarudaLounge.',
                          style: TextStyle(fontSize: 20, color: red),
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  } else {
                    // filter data dari snapshot sebelum ditampilkan
                    List<MerchEntry> displayedMerch;
                    if (_currentFilter == 'all') {
                      displayedMerch = snapshot.data!;
                    } else {
                      displayedMerch = snapshot.data!.where((merch) {
                        String merchType = merch.category.toLowerCase().trim();
                        String filterType = _currentFilter.toLowerCase().trim();
                        return merchType.contains(filterType);
                      }).toList();
                    }
                    if (displayedMerch.isEmpty) {
                      return Center(
                        child: Text(
                          'Tidak ada merchandise "${titled(_currentFilter)}"',
                          style: TextStyle(color: red, fontSize: 20),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: displayedMerch.length,
                      itemBuilder: (_, index) {
                        final MerchEntry merch = displayedMerch[index];
                        
                        return MerchEntryCard(
                          merch: merch,
                          isStaff: isStaff,
                          onTap: () {
                            // Navigate to merch detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MerchDetailPage(
                                  merch: snapshot.data![index],
                                ),
                              ),
                            );
                          },

                          onEdit: () async {
                            final result = await showDialog(
                              context: context,
                              builder: (context) => MerchFormPage(
                                merch: merch, // buka modal form, terus kirim data merch yang diklik sebagai parameter
                              ),
                            );

                            // refresh halaman ika berhasil tamabah atau edit merch
                            if (result == true) {
                              setState(() {
                                
                              });
                            }
                          },

                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // ambil lebar layar untuk logika responsive
                                final double screenWidth = MediaQuery.of(context).size.width;
                                
                                // tentukan padding dinamis (kecil di layar sempit, standar di layar lebar)
                                final double dynamicPadding = screenWidth < 400 ? 16.0 : 24.0; 
                                final double buttonPadding = screenWidth < 400 ? 10.0 : 14.0;

                                return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: 0,
                                  backgroundColor: Colors.white, // atau transparent?
                                  insetPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxHeight: MediaQuery.of(context).size.height * 0.9,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: black, width: 2),
                                      boxShadow: const [
                                        BoxShadow(color: black, offset: Offset(6, 6), blurRadius: 0),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // header form
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                          decoration: const BoxDecoration(
                                            color: cream,
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                                            border: Border(bottom: BorderSide(color: gray, width: 1)),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Hapus Merch Ini?",
                                                    style: TextStyle(
                                                        fontSize: 18, fontWeight: FontWeight.w900, color: black),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.close, color: black),
                                                onPressed: () => Navigator.pop(context),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 16),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () => Navigator.pop(context),
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                  side: const BorderSide(color: black, width: 2),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                  foregroundColor: black,
                                                  backgroundColor: white,
                                                ),
                                                child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
                                              ),
                                            ),

                                            const SizedBox(width: 12),

                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                                  side: const BorderSide(color: black, width: 2),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                  foregroundColor: white,
                                                  backgroundColor: red,
                                                ),
                                                onPressed: () async {
                                                Navigator.of(context).pop(); // tutup dialog dulu
                                                
                                                try {
                                                  // kirim request ke Django
                                                  final response = await request.postJson(
                                                    'https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id/merchandise/delete-flutter/${merch.id}/', 
                                                    jsonEncode({"id": merch.id}),
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
                                                        const SnackBar(content: Text("Gagal menghapus merch.")),
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
                                              child: const Text("Delete", style: TextStyle(color: white, fontWeight: FontWeight.bold)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
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