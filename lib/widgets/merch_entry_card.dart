import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/merch_entry.dart';

class MerchEntryCard extends StatelessWidget {
  final MerchEntry merch;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MerchEntryCard({
    super.key,
    required this.merch,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFFAA1515)),
          ),
          elevation: 3,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Thumbnail =====
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                    'http://localhost:8000/proxy-image/?url=${Uri.encodeComponent(merch.thumbnail)}',
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

              // ===== Body =====
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      merch.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFAA1515),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Category
                    Text(
                      merch.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Price
                    Text(
                      "Rp.${merch.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 6),  

                    // Description
                    Text(
                      merch.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),
                    const Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}