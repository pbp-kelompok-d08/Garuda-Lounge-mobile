// To parse this JSON data, do
//
//   final comments = commentEntryFromJson(jsonString);

import 'dart:convert';

List<CommentEntry> commentEntryFromJson(String str) =>
    List<CommentEntry>.from(
      json.decode(str).map((x) => CommentEntry.fromJson(x)),
    );

String commentEntryToJson(List<CommentEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentEntry {
  final String id;           // UUID
  final String newsId;       // UUID News
  final int userId;          // id user
  final String userUsername; // username
  final String content;      // isi komentar
  final DateTime createdAt;  // waktu dibuat

  CommentEntry({
    required this.id,
    required this.newsId,
    required this.userId,
    required this.userUsername,
    required this.content,
    required this.createdAt,
  });

  factory CommentEntry.fromJson(Map<String, dynamic> json) => CommentEntry(
    id: json["id"].toString(),
    newsId: json["news_id"].toString(),
    userId: json["user_id"],
    userUsername: json["user_username"] ?? "",
    content: json["content"] ?? "",
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "news_id": newsId,
    "user_id": userId,
    "user_username": userUsername,
    "content": content,
    "created_at": createdAt.toIso8601String(),
  };
}
