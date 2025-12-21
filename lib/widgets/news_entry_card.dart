import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/news_entry.dart';

class NewsEntryCard extends StatelessWidget {
  final NewsEntry news;
  final VoidCallback onTap;

  const NewsEntryCard({
    super.key,
    required this.news,
    required this.onTap,
  });

  static const Color red = Color(0xFFAA1515);
  static const Color cream = Color(0xFFE7E3DD);
  static const Color black = Color(0xFF111111);
  static const Color grey = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'http://127.0.0.1:8000';

    final String thumb = news.thumbnail.trim();
    final String imgUrl =
        '$baseUrl/news/proxy-image/?url=${Uri.encodeComponent(thumb)}';

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cream,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: red, width: 1.4),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IMAGE: fixed height biar nggak kegedean
            SizedBox(
              height: 140, // bisa 130–160 sesuai selera
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFD1D5DB),
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),

            // HAPUS Expanded: biar card bisa “ngikut” konten (lebih kompak)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE lebih pendek
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: red,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // META
                  Text(
                    news.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ✅ CONTENT lebih pendek
                  Text(
                    news.content,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: black,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (news.isFeatured) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Featured',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],

                  const Text(
                    'Baca →',
                    style: TextStyle(
                      color: red,
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
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
}
