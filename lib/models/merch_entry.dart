// To parse this JSON data, do
//
//     final merchEntry = merchEntryFromJson(jsonString);

import 'dart:convert';

List<MerchEntry> merchEntryFromJson(String str) => List<MerchEntry>.from(json.decode(str).map((x) => MerchEntry.fromJson(x)));

String merchEntryToJson(List<MerchEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MerchEntry {
    String id;
    String name;
    String description;
    String category;
    String thumbnail;
    int price;
    String productLink;
    int userId;
    String userUsername;

    MerchEntry({
        required this.id,
        required this.name,
        required this.description,
        required this.category,
        required this.thumbnail,
        required this.price,
        required this.productLink,
        required this.userId,
        required this.userUsername,
    });

    factory MerchEntry.fromJson(Map<String, dynamic> json) => MerchEntry(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        price: json["price"],
        productLink: json["product_link"],
        userId: json["user_id"],
        userUsername: json["user_username"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category,
        "thumbnail": thumbnail,
        "price": price,
        "product_link": productLink,
        "user_id": userId,
        "user_username": userUsername,
    };
}
