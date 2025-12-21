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

  @override
  Widget build(BuildContext context) {
    // Warna tema Garuda Lounge
    const Color red = Color(0xFFAA1515);
    const Color cream = Color(0xFFE7E3DD);
    const Color black = Color(0xFF111111);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    // Pastikan endpoint proxy-mu benar
                    'http://localhost:8000/news/proxy-image/?url=${Uri.encodeComponent(news.thumbnail)}',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Title
                Text(
                  news.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),
                const SizedBox(height: 6),

                // Category
                Text(
                  'Category: ${news.category}',
                  style: TextStyle(color: black.withOpacity(0.7)),
                ),
                const SizedBox(height: 6),

                // Content preview
                Text(
                  news.content.length > 100
                      ? '${news.content.substring(0, 100)}...'
                      : news.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: black.withOpacity(0.5)),
                ),
                const SizedBox(height: 8),

                // Featured indicator
                if (news.isFeatured)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Featured',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
