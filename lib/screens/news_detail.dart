import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/news_entry.dart';
import 'package:garuda_lounge_mobile/widgets/comment_section.dart';

const Color red = Color(0xFFAA1515);
const Color white = Color(0xFFFFFFFF);
const Color cream = Color(0xFFE7E3DD);
const Color black = Color(0xFF111111);
const Color gray = Color(0xFF374151);

class NewsDetailPage extends StatelessWidget {
  final NewsEntry news;

  const NewsDetailPage({super.key, required this.news});

  String _formatDate(DateTime date) {
    final months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text('News Detail'),
        backgroundColor: red,
        foregroundColor: white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===== THUMBNAIL =====
            if (news.thumbnail.isNotEmpty)
              Image.network(
                'http://localhost:8000/news/proxy-image/?url=${Uri.encodeComponent(news.thumbnail)}',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),

            // ===== CONTENT =====
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if (news.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Featured',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: white,
                          ),
                        ),
                      ),

                    Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: cream,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            news.category.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatDate(news.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: gray.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(Icons.visibility,
                            size: 16, color: gray.withOpacity(0.7)),
                        const SizedBox(width: 4),
                        Text(
                          '${news.newsViews} views',
                          style: TextStyle(
                            fontSize: 12,
                            color: gray.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 32),

                    Text(
                      news.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: black,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),

            // ===== COMMENTS =====
            CommentSection(newsId: news.id),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
