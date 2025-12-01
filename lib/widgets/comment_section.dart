import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/models/comment_entry.dart';
import 'package:garuda_lounge_mobile/services/comment_api_service.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CommentSection extends StatefulWidget {
  final String newsId;

  const CommentSection({super.key, required this.newsId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final commentService = CommentApiService(request);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Comments",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // LIST COMMENT
          FutureBuilder<List<CommentEntry>>(
            future: commentService.fetchComments(widget.newsId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final comments = snapshot.data!;

              if (comments.isEmpty) {
                return const Text("No comments yet.");
              }

              return Column(
                children: comments.map((c) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                      Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.userUsername,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(c.content),
                        const SizedBox(height: 4),
                        Text(
                          "${c.createdAt.day}/${c.createdAt.month}/${c.createdAt.year} "
                              "${c.createdAt.hour}:${c.createdAt.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 11),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 20),

          // INPUT COMMENT
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // BUTTON POST
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAA1515),
                ),
                onPressed: () async {
                  final content = _commentController.text.trim();

                  if (content.isEmpty) return;

                  final ok = await commentService.postComment(
                    widget.newsId,
                    content,
                  );

                  if (ok) {
                    _commentController.clear();
                    setState(() {}); // Refresh list
                  }
                },
                child: const Text("Post"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
