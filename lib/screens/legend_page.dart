import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/legend_entry.dart';
import 'legend_form.dart';

class LegendPlayersPage extends StatefulWidget {
  const LegendPlayersPage({super.key});
  @override
  State<LegendPlayersPage> createState() => _LegendPlayersPageState();
}

class _LegendPlayersPageState extends State<LegendPlayersPage> {
  String _selectedPos = "";
  Future<List<LegendEntry>>? _future;

  Future<List<LegendEntry>> _fetch(CookieRequest req) async {
    final res = await req.get("https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id/ProfileLegend/json/");
    return List<LegendEntry>.from(res.map((i) => LegendEntry.fromJson(i)));
  }

  @override
  Widget build(BuildContext context) {
    final req = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: dsCream,
      appBar: AppBar(title: const Text("GARUDA LEGENDS", style: TextStyle(color: dsRed, fontWeight: FontWeight.w900)), backgroundColor: dsWhite),
      body: FutureBuilder<List<LegendEntry>>(
        future: _future ?? _fetch(req),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: dsRed));
          final list = _selectedPos.isEmpty ? snapshot.data! : snapshot.data!.where((p) => p.position == _selectedPos).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedPos,
                        decoration: InputDecoration(filled: true, fillColor: dsWhite, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                        items: ["", "Kiper", "Bek", "Gelandang", "Penyerang"].map((e) => DropdownMenuItem(value: e, child: Text(e == "" ? "Semua" : e))).toList(),
                        onChanged: (v) => setState(() => _selectedPos = v!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: dsRed),
                      onPressed: () async {
                        final res = await showDialog<bool>(context: context, builder: (_) => const LegendPlayerForm());
                        if (res == true) setState(() => _future = _fetch(req));
                      },
                      child: const Text("+ LEGEND", style: TextStyle(color: dsWhite)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 0.75),
                  itemCount: list.length,
                  itemBuilder: (context, index) => _LegendCard(legend: list[index], onRefresh: () => setState(() => _future = _fetch(req))),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LegendCard extends StatelessWidget {
  final LegendEntry legend;
  final VoidCallback onRefresh;
  const _LegendCard({required this.legend, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: dsWhite, borderRadius: BorderRadius.circular(20), border: Border.all(color: dsRed, width: 2)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            Expanded(child: Image.network(legend.photoUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.person, size: 50))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(legend.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, color: dsRed, fontSize: 13), maxLines: 1),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: dsBlack, minimumSize: const Size(double.infinity, 30)),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LegendDetailPage(legend: legend, onRefresh: onRefresh))),
                    child: const Text("DETAIL", style: TextStyle(color: dsWhite, fontSize: 10)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LegendDetailPage extends StatelessWidget {
  final LegendEntry legend;
  final VoidCallback onRefresh;
  const LegendDetailPage({super.key, required this.legend, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dsCream,
      appBar: AppBar(title: Text(legend.name), backgroundColor: dsRed, foregroundColor: dsWhite),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(legend.photoUrl, height: 300, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(title: const Text("Posisi"), subtitle: Text(legend.position)),
                    ListTile(title: const Text("Klub"), subtitle: Text(legend.club)),
                    ListTile(title: const Text("Umur"), subtitle: Text("${legend.age} Tahun")),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("EDIT DATA"),
              onPressed: () async {
                final res = await showDialog<bool>(context: context, builder: (_) => LegendPlayerForm(legend: legend));
                if (res == true) {
                  onRefresh();
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}