import 'dart:convert';

List<LegendEntry> legendEntryFromJson(String str) =>
    List<LegendEntry>.from(json.decode(str).map((x) => LegendEntry.fromJson(x)));

class LegendEntry {
  String id;
  String name;
  String position;
  int age;
  String club;
  String photoUrl;
  bool isLegend;

  LegendEntry({
    required this.id,
    required this.name,
    required this.position,
    required this.age,
    required this.club,
    required this.photoUrl,
    required this.isLegend,
  });

  factory LegendEntry.fromJson(Map<String, dynamic> json) => LegendEntry(
        id: json["id"],
        name: json["name"],
        position: json["position"],
        age: json["age"] ?? 0,
        club: json["club"] ?? "",
        photoUrl: json["photo_url"] ?? "",
        isLegend: json["is_legend"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "position": position,
        "age": age,
        "club": club,
        "photo_url": photoUrl,
        "is_legend": isLegend,
      };
}