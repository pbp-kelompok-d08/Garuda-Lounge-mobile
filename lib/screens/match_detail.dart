import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/match_entry.dart';
import 'package:garuda_lounge_mobile/main.dart';
import 'package:garuda_lounge_mobile/widgets/match_entry_card.dart';
// import 'package:garuda_lounge_mobile/main.dart';
// import 'package:garuda_lounge_mobile/widgets/match_entry_card.dart';
// import 'package:garuda_lounge_mobile/screens/match_entry_list.dart';
// import 'package:flutter/material.dart';
// import 'package:garuda_lounge_mobile/models/match_entry.dart';

// import 'package:url_launcher/url_launcher.dart';

class MatchDetailPage extends StatefulWidget {
  final MatchEntry match;

  const MatchDetailPage({super.key, required this.match});

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  int _selectedIndex = 0; // 0 = lineup, 1 = statistik

  List<String> getListFromString(String data) {
    if (data == "-" || data.isEmpty || data == "None") return [];
    return data.split(';').map((e) => e.trim()).toList(); 
  }

  // Future<void> _launchURL(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (!await launchUrl(uri)) {
  //     throw Exception('Could not launch $uri');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    
    // pertandingan persahabtan tidak punya detail line up dan statisik, cuma ada highlight aja
    bool isFriendly = match.jenisPertandingan.toLowerCase().contains('persahabatan');
    // pertandingan piala asean tidak punya detail statistik
    bool isAseanCup = match.jenisPertandingan.toLowerCase().contains('piala asean');

    List<String> homeScorers = getListFromString(match.pencetakGolTuanRumah);
    List<String> awayScorers = getListFromString(match.pencetakGolTamu);

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text("Match Details", style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        backgroundColor: red,
        iconTheme: const IconThemeData(color: white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            // card
            Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: black,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // header: jenis pertandingan dan tanggal
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                titled(match.jenisPertandingan),
                                style: const TextStyle(color: white, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              match.tanggal,
                              style: const TextStyle(color: black, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // skor dan tim
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // tuan rumah
                            Expanded(
                              child: Column(
                                children: [
                                  Image.network(match.benderaTuanRumah, height: 60, errorBuilder: (_,__,___) => const Icon(Icons.flag)),
                                  const SizedBox(height: 8),
                                  Text(
                                    match.timTuanRumah,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: black),
                                  ),
                                ],
                              ),
                            ),
                            // skor
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                " ${match.skorTuanRumah}  -  ${match.skorTamu} ",
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                            ),
                            // tamu
                            Expanded(
                              child: Column(
                                children: [
                                  Image.network(match.benderaTamu, height: 60, errorBuilder: (_,__,___) => const Icon(Icons.flag)),
                                  const SizedBox(height: 8),
                                  Text(
                                    match.timTamu,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // pencetak gol
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[100]!))),
                    child: Column(
                      children: [
                        Text("Pencetak Gol", style: TextStyle(color: red, fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: homeScorers.map((p) => Text(p, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: black))).toList(),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: awayScorers.map((p) => Text(p, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: black))).toList(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  // HIGHLIGHT BUTTON
                  if (match.highlight.isNotEmpty && match.highlight != "-")
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: red))),
                    child: ElevatedButton(
                      // onPressed: () => _launchURL(match.highlight),
                      onPressed: () => (match.highlight),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red, 
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Lihat Highlight", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),

                  // TABS SECTION (Hanya jika bukan Friendly Match)
                  if (!isFriendly) ...[
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: red),
                          bottom: BorderSide(color: Colors.grey[200]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildTabButton("Susunan Pemain", 0),
                          _buildTabButton("Statistik", 1),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _selectedIndex == 0
                          ? _buildLineupContent(match)
                          : _buildStatsContent(match, isAseanCup),
                    ),
                  ],

                  // FOOTER: STADION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(border: Border(top: BorderSide(color:red))),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        children: [
                          TextSpan(text: "Tempat: ", style: TextStyle(color: red, fontWeight: FontWeight.w600)),
                          TextSpan(text: "Stadion ${match.stadion}", style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isActive = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: isActive ? Border(bottom: BorderSide(color: red, width: 2)) : null,
            color: isActive ? Colors.grey[50] : Colors.white,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? red : gray),
          ),
        ),
      ),
    );
  }

  // LOGIKA LINEUP (Menggabungkan String menjadi pasangan)
  Widget _buildLineupContent(MatchEntry match) {
    // Parsing String starter/subs menjadi List
    List<String> homeStarters = getListFromString(match.starterTuanRumah);
    List<String> awayStarters = getListFromString(match.starterTamu);
    List<String> homeSubs = getListFromString(match.penggantiTuanRumah);
    List<String> awaySubs = getListFromString(match.penggantiTamu);

    return Column(
      children: [
        Text("Starting Eleven", style: TextStyle(color: red, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _buildPairedList(homeStarters, awayStarters),

        const SizedBox(height: 24),
        Text("Pengganti", style: TextStyle(color: red, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _buildPairedList(homeSubs, awaySubs),

        const SizedBox(height: 24),
        Text("Manajer", style: TextStyle(color: red, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _buildPlayerRow(match.manajerTuanRumah, match.manajerTamu)
      ],
    );
  }

  // Helper untuk menampilkan list pemain kiri-kanan
  Widget _buildPairedList(List<String> home, List<String> away) {
    // Cari panjang list terpanjang agar tidak error index out of bounds
    int count = home.length > away.length ? home.length : away.length;
    if (count == 0) return const Text("-");

    return Column(
      children: List.generate(count, (index) {
        String h = index < home.length ? home[index] : "";
        String a = index < away.length ? away[index] : "";
        return _buildPlayerRow(h, a);
      }),
    );
  }

  Widget _buildPlayerRow(String home, String away) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(home, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          Expanded(child: Text(away, textAlign: TextAlign.right, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  // LOGIKA STATISTIK
  Widget _buildStatsContent(MatchEntry match, bool isAseanCup) {
    if (isAseanCup) return const Center(child: Text("Statistik tidak tersedia untuk Piala Asean"));

    return Column(
      children: [
        _buildStatRow("${match.penguasaanBolaTuanRumah}%", "Penguasaan Bola", "${match.penguasaanBolaTamu}%"),
        _buildStatRow(match.tembakanTuanRumah, "Tembakan", match.tembakanTamu),
        _buildStatRow(match.onTargetTuanRumah, "Tembakan ke Gawang", match.onTargetTamu),
        _buildStatRow("${match.akurasiUmpanTuanRumah}%", "Akurasi Umpan", "${match.akurasiUmpanTamu}%"),
        _buildStatRow(match.pelanggaranTuanRumah, "Pelanggaran", match.pelanggaranTamu),
        _buildStatRow(match.kartuKuningTuanRumah, "Kartu Kuning", match.kartuKuningTamu),
        _buildStatRow(match.kartuMerahTuanRumah, "Kartu Merah", match.kartuMerahTamu),
        _buildStatRow(match.offsideTuanRumah, "Offside", match.offsideTamu),
        _buildStatRow(match.cornerTuanRumah, "Sepak Pojok", match.cornerTamu),
      ],
    );
  }

  Widget _buildStatRow(String homeVal, String label, String awayVal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 40, child: Text(homeVal, style: const TextStyle(fontWeight: FontWeight.bold))),
          Text(label, style: TextStyle(color: red, fontWeight: FontWeight.w600, fontSize: 13)),
          SizedBox(width: 40, child: Text(awayVal, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}