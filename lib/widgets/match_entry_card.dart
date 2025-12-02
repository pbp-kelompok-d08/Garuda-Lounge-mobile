import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/match_entry.dart';
import 'package:garuda_lounge_mobile/main.dart';


class MatchEntryCard extends StatelessWidget {
  final MatchEntry match;
  final VoidCallback onTap;
  final VoidCallback onEditPressed; // untuk navigasi ke edit
  final VoidCallback onDeletePressed; // untuk logika delete

  const MatchEntryCard({
    super.key,
    required this.match,
    required this.onTap,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header: jenis dan tanggal
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary, // warna background header
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // tanda jenis pertandingan
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  child: Text(
                    titled(match.jenisPertandingan), // category
                    style: TextStyle(
                      color: white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                // tanggal
                Text(
                  match.tanggal, // Pastikan field tanggal ada di model Anda
                  style: const TextStyle(color: black, fontSize: 12),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1.5, color: red,),

          // body: tim dan skor
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTeamRow(
                  context,
                  teamName: match.timTuanRumah,
                  flagUrl: match.benderaTuanRumah,
                  score: match.skorTuanRumah,
                ),

                const SizedBox(height: 12), // jarak antar tim

                _buildTeamRow(
                  context,
                  teamName: match.timTamu,
                  flagUrl: match.benderaTamu,
                  score: match.skorTamu,
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1.5, color: red,),

          // footer action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const Text(
                //   "Details",
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     color: Colors.blue,
                //   ),
                // ),
                // // tombol edit, delete, detail 
                // Row(
                //   children: [
                //     Icon(Icons.edit, size: 20, color: Colors.orange[300]),
                //     const SizedBox(width: 8),
                //     Icon(Icons.delete, size: 20, color: Colors.red[300]),
                //   ],
                // )

                TextButton(
                  onPressed: onTap, 
                  child: const Text(
                    "Detail Pertandingan ->",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: red,
                      fontSize: 13,
                    ),
                  ),
                ),
                
                Row(
                  children: [
                    TextButton(
                      onPressed: onEditPressed, 
                      child: const Text(
                        "Edit",
                        style: TextStyle(
                          fontWeight: FontWeight.normal, 
                          color: Color.fromARGB(255, 96, 95, 95), 
                          fontSize: 14,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: onDeletePressed, 
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          fontWeight: FontWeight.normal, 
                          color: Color.fromARGB(255, 129, 11, 11),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ]
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// helper widget untuk membuat baris tiap tim 
Widget _buildTeamRow(
  BuildContext context, {
  required String teamName, 
  required String flagUrl, 
  required dynamic score
  }) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // kiri: bendera + nama tim
      Expanded(
        child: Row(
          children: [
            // gambar bendera 
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                'http://localhost:8000/proxy-image/?url=${Uri.encodeComponent(flagUrl)}',
                width: 40, 
                height: 25,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 40,
                  height: 25,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 15),
                ),
              ),
            ),
            const SizedBox(width: 12), // jarak bendera ke nama tim
            // nama Tim
            Expanded(
              child: Text(
                teamName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      // kanan: skor
      Text(
        score.toString(),
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
  }
}

String titled(String text) {
    String result = "";
    for (String s in text.split(" ")) {
      result = "$result${s[0].toUpperCase()}${s.substring(1)} ";
    }

    return result;
  }