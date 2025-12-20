import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:garuda_lounge_mobile/models/news_entry.dart';
import 'package:garuda_lounge_mobile/widgets/left_drawer.dart';
import 'package:garuda_lounge_mobile/screens/news_detail.dart';
import 'package:garuda_lounge_mobile/widgets/news_entry_card.dart';
import 'package:garuda_lounge_mobile/screens/newslist_form.dart';

import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:garuda_lounge_mobile/screens/newslist_form.dart';

class NewsEntryListPage extends StatefulWidget {
  const NewsEntryListPage({super.key});

  @override
  State<NewsEntryListPage> createState() => _NewsEntryListPageState();
}

class _NewsEntryListPageState extends State<NewsEntryListPage> {
  static const Color red = Color(0xFFAA1515);
  static const Color cream = Color(0xFFE7E3DD);
  static const Color black = Color(0xFF111111);

  Future<List<NewsEntry>> fetchNews(CookieRequest request) async {
    final baseUrl =
    kIsWeb ? "http://localhost:8000" : "http://10.0.2.2:8000";

    final response = await request.get('$baseUrl/news/json/');

    List<NewsEntry> listNews = [];
    for (var d in response) {
      if (d != null) listNews.add(NewsEntry.fromJson(d));
    }
    return listNews;
  }

  int _calcColumns(double width) {
    if (width < 650) return 1;
    if (width < 980) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: cream,
      drawer: const LeftDrawer(),

      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              backgroundColor: cream,
              elevation: innerBoxIsScrolled ? 1 : 0,
              toolbarHeight: 64,
              iconTheme: const IconThemeData(color: black),
              title: const Text(
                'Garuda Lounge News',
                style: TextStyle(color: black, fontWeight: FontWeight.w800),
              ),
            ),
          ];
        },

        body: FutureBuilder(
          future: fetchNews(request),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'There are no news in Garuda Lounge yet.',
                  style: TextStyle(fontSize: 18, color: black),
                ),
              );
            }

            final list = snapshot.data!;

            return LayoutBuilder(
              builder: (context, constraints) {
                final columns = _calcColumns(constraints.maxWidth);

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: _PillButton(
                                label: "← Back to Main Page",
                                filled: true,
                                onTap: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              "Garuda Lounge News",
                              style: TextStyle(
                                color: red,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                _PillButton(
                                  label: "All News",
                                  filled: true,
                                  onTap: () {},
                                ),
                                _PillButton(
                                  label: "My News",
                                  filled: false,
                                  onTap: () {},
                                ),
                                _PillButton(
                                  label: "+ Tambah Berita",
                                  filled: true,
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      barrierDismissible: true, // klik area gelap = dialog tertutup
                                      builder: (BuildContext dialogContext) {
                                        return NewsFormDialog(
                                          request: request,
                                          onSuccess: () {
                                            // Tutup dialog kalau belum ketutup
                                            if (Navigator.of(dialogContext).canPop()) {
                                              Navigator.of(dialogContext).pop();
                                            }

                                            // Refresh list berita
                                            setState(() {});
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.98,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final news = list[index];
                            return NewsEntryCard(
                              news: news,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NewsDetailPage(news: news),
                                  ),
                                );
                              },
                            );
                          },
                          childCount: list.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  static const Color red = Color(0xFFAA1515);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: filled ? red : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: red, width: 1.2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: filled ? Colors.white : red,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}