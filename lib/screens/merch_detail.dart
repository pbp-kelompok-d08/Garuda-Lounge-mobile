import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/merch_entry.dart';
import 'package:url_launcher/url_launcher.dart';

const Color red = Color(0xFFAA1515);
const Color white = Color(0xFFFFFFFF);
const Color cream = Color(0xFFE7E3DD);
const Color black = Color(0xFF111111);
const Color gray = Color(0xFF374151);

class MerchDetailPage extends StatelessWidget {
  final MerchEntry merch;

  const MerchDetailPage({super.key, required this.merch});

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(merch.productLink);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch URL");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merch Detail'),
        backgroundColor: red,
        foregroundColor: white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail image
            if (merch.thumbnail.isNotEmpty)
              Image.network(
                'http://localhost:8000/proxy-image/?url=${Uri.encodeComponent(merch.thumbnail)}',
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
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    merch.name,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.0),
                        decoration: BoxDecoration(
                          color: cream,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          merch.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Rp. ${merch.price}',
                        style: TextStyle(
                          fontSize: 12,
                          color: gray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  const Divider(height: 32),

                  // Full description
                  Text(
                    merch.description,
                    style: const TextStyle(
                      fontSize: 16.0,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),

                  // Product Link
                  ElevatedButton(
                    onPressed: _launchURL,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: red,
                      foregroundColor: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      )
                    ),
                    child: Text("Buy Product"),
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