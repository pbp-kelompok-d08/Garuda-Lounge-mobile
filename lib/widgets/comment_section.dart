import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

const Color red = Color(0xFFAA1515);
const Color cream = Color(0xFFE7E3DD);
const Color black = Color(0xFF111111);
const Color gray = Color(0xFF374151);

class CommentSection extends StatefulWidget {
  final String newsId;
  const CommentSection({super.key, required this.newsId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;

  Future<List<Map<String, dynamic>>> _fetchComments(CookieRequest request) async {
    final url = "http://localhost:8000/news/api/${widget.newsId}/comments/";
    final res = await request.get(url);

    // res biasanya bentuknya: {"comments": [...]}
    final list = (res["comments"] as List?) ?? [];
    return list.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> _postComment(CookieRequest request) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _loading = true);

    final url = "http://localhost:8000/news/api/${widget.newsId}/comments/add/";

    try {
      final res = await request.postJson(
        url,
        jsonEncode({"content": text}),
      );

      // kalau sukses, bersihin input + refresh list
      _controller.clear();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal kirim komentar: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          const Text(
            "Comments",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: black,
            ),
          ),
          const SizedBox(height: 12),

          // LIST KOMENTAR
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchComments(request),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final comments = snapshot.data!;
              if (comments.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: const Text(
                    "Belum ada komentar.",
                    style: TextStyle(color: gray),
                  ),
                );
              }

              return Column(
                children: comments.map((c) {
                  final user = (c["user"] ?? "Anonymous").toString();
                  final content = (c["content"] ?? "").toString();
                  final createdAt = (c["created_at"] ?? "").toString();

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          content,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700, // biar kaya di gambar
                            color: black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          createdAt,
                          style: TextStyle(
                            fontSize: 12,
                            color: gray.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 10),

          // INPUT + TOMBOL POST
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Write a comment...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : () => _postComment(request),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  child: _loading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text(
                    "Post",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
