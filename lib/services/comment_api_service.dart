import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:garuda_lounge_mobile/models/comment_entry.dart';

class CommentApiService {
  final CookieRequest request;

  CommentApiService(this.request);

  // Ambil komentar berdasarkan ID News (UUID)
  Future<List<CommentEntry>> fetchComments(String newsId) async {
    final response = await request.get(
      'http://localhost:8000/news/api/$newsId/comments/',
    );

    List<CommentEntry> comments = [];
    for (var d in response) {
      if (d != null) {
        comments.add(CommentEntry.fromJson(d));
      }
    }
    return comments;
  }

  // Kirim komentar baru
  Future<bool> postComment(String newsId, String content) async {
    final response = await request.postJson(
      'http://localhost:8000/news/api/$newsId/comments/add/',
      jsonEncode({
        "content": content,
      }),
    );

    return response['status'] == 'success';
  }
}
