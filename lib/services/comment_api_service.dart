import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class CommentApiService {
  // FIX: untuk Flutter Web di laptop
  static const String baseUrl = "https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id";

  static Future<List<dynamic>> fetchComments(CookieRequest request, String newsId) async {
    final res = await request.get("$baseUrl/news/api/$newsId/comments/");

    if (res is Map && res["comments"] is List) {
      return res["comments"];
    }
    return [];
  }

  static Future<Map<String, dynamic>> addComment(
      CookieRequest request,
      String newsId,
      String content,
      ) async {
    final res = await request.postJson(
      "$baseUrl/news/api/$newsId/comments/add/",
      jsonEncode({"content": content}),
    );

    // res harusnya Map
    if (res is Map) {
      return Map<String, dynamic>.from(res);
    }
    return {"error": "Invalid response"};
  }
}
