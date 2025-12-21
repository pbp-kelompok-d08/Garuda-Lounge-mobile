import 'dart:convert';

List<PlayerEntry> playerEntryFromJson(String str) =>
    List<PlayerEntry>.from(json.decode(str).map((x) => PlayerEntry.fromJson(x)));

String playerEntryToJson(List<PlayerEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlayerEntry {
  final String id;
  final String nama;
  final Posisi posisi;
  final PosisiKode posisiKode;
  final String klub;
  final int umur;
  final double marketValue;
  final String foto;

  PlayerEntry({
    required this.id,
    required this.nama,
    required this.posisi,
    required this.posisiKode,
    required this.klub,
    required this.umur,
    required this.marketValue,
    required this.foto,
  });

  factory PlayerEntry.fromJson(Map<String, dynamic> json) {
    final rawPosisi = (json["posisi"] ?? "").toString().trim();
    final rawKode = (json["posisi_kode"] ?? "").toString().trim().toUpperCase();

    return PlayerEntry(
      id: json["id"].toString(),
      nama: (json["nama"] ?? "").toString(),
      posisi: posisiValues.map[rawPosisi] ?? Posisi.MIDFIELDER,
      posisiKode: posisiKodeValues.map[rawKode] ?? PosisiKode.MF,
      klub: (json["klub"] ?? "").toString(),
      umur: (json["umur"] as num?)?.toInt() ?? 0,
      marketValue: (json["market_value"] as num?)?.toDouble() ?? 0,
      foto: (json["foto"] ?? "").toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "posisi": posisiValues.reverse[posisi],
    "posisi_kode": posisiKodeValues.reverse[posisiKode],
    "klub": klub,
    "umur": umur,
    "market_value": marketValue,
    "foto": foto,
  };
}

enum Posisi { DEFENDER, FORWARD, GOALKEEPER, MIDFIELDER }

final posisiValues = EnumValues({
  "Defender": Posisi.DEFENDER,
  "Forward": Posisi.FORWARD,
  "Goalkeeper": Posisi.GOALKEEPER,
  "Midfielder": Posisi.MIDFIELDER,
});

enum PosisiKode { DF, FW, GK, MF }

final posisiKodeValues = EnumValues({
  "DF": PosisiKode.DF,
  "FW": PosisiKode.FW,
  "GK": PosisiKode.GK,
  "MF": PosisiKode.MF,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
