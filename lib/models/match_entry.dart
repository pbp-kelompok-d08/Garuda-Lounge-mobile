// To parse this JSON data, do
//
//     final matchEntry = matchEntryFromJson(jsonString);

import 'dart:convert';

List<MatchEntry> matchEntryFromJson(String str) => List<MatchEntry>.from(json.decode(str).map((x) => MatchEntry.fromJson(x)));

String matchEntryToJson(List<MatchEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MatchEntry {
    String id;
    String jenisPertandingan;
    String timTuanRumah;
    String timTamu;
    String benderaTuanRumah;
    String benderaTamu;
    String tanggal;
    String stadion;
    String skorTuanRumah;
    String skorTamu;
    String pencetakGolTuanRumah;
    String pencetakGolTamu;
    String starterTuanRumah;
    String starterTamu;
    String penggantiTuanRumah;
    String penggantiTamu;
    String manajerTuanRumah;
    String manajerTamu;
    String highlight;
    String penguasaanBolaTuanRumah;
    String penguasaanBolaTamu;
    String tembakanTuanRumah;
    String tembakanTamu;
    String onTargetTuanRumah;
    String onTargetTamu;
    String akurasiUmpanTuanRumah;
    String akurasiUmpanTamu;
    String pelanggaranTuanRumah;
    String pelanggaranTamu;
    String kartuKuningTuanRumah;
    String kartuKuningTamu;
    String kartuMerahTuanRumah;
    String kartuMerahTamu;
    String offsideTuanRumah;
    String offsideTamu;
    String cornerTuanRumah;
    String cornerTamu;

    MatchEntry({
        required this.id,
        required this.jenisPertandingan,
        required this.timTuanRumah,
        required this.timTamu,
        required this.benderaTuanRumah,
        required this.benderaTamu,
        required this.tanggal,
        required this.stadion,
        required this.skorTuanRumah,
        required this.skorTamu,
        required this.pencetakGolTuanRumah,
        required this.pencetakGolTamu,
        required this.starterTuanRumah,
        required this.starterTamu,
        required this.penggantiTuanRumah,
        required this.penggantiTamu,
        required this.manajerTuanRumah,
        required this.manajerTamu,
        required this.highlight,
        required this.penguasaanBolaTuanRumah,
        required this.penguasaanBolaTamu,
        required this.tembakanTuanRumah,
        required this.tembakanTamu,
        required this.onTargetTuanRumah,
        required this.onTargetTamu,
        required this.akurasiUmpanTuanRumah,
        required this.akurasiUmpanTamu,
        required this.pelanggaranTuanRumah,
        required this.pelanggaranTamu,
        required this.kartuKuningTuanRumah,
        required this.kartuKuningTamu,
        required this.kartuMerahTuanRumah,
        required this.kartuMerahTamu,
        required this.offsideTuanRumah,
        required this.offsideTamu,
        required this.cornerTuanRumah,
        required this.cornerTamu,
    });

    factory MatchEntry.fromJson(Map<String, dynamic> json) => MatchEntry(
        id: json["id"],
        jenisPertandingan: json["jenis_pertandingan"],
        timTuanRumah: json["tim_tuan_rumah"],
        timTamu: json["tim_tamu"],
        benderaTuanRumah: json["bendera_tuan_rumah"],
        benderaTamu: json["bendera_tamu"],
        tanggal: json["tanggal"],
        stadion: json["stadion"],
        skorTuanRumah: json["skor_tuan_rumah"],
        skorTamu: json["skor_tamu"],
        pencetakGolTuanRumah: json["pencetak_gol_tuan_rumah"],
        pencetakGolTamu: json["pencetak_gol_tamu"],
        starterTuanRumah: json["starter_tuan_rumah"],
        starterTamu: json["starter_tamu"],
        penggantiTuanRumah: json["pengganti_tuan_rumah"],
        penggantiTamu: json["pengganti_tamu"],
        manajerTuanRumah: json["manajer_tuan_rumah"],
        manajerTamu: json["manajer_tamu"],
        highlight: json["highlight"],
        penguasaanBolaTuanRumah: json["penguasaan_bola_tuan_rumah"],
        penguasaanBolaTamu: json["penguasaan_bola_tamu"],
        tembakanTuanRumah: json["tembakan_tuan_rumah"],
        tembakanTamu: json["tembakan_tamu"],
        onTargetTuanRumah: json["on_target_tuan_rumah"],
        onTargetTamu: json["on_target_tamu"],
        akurasiUmpanTuanRumah: json["akurasi_umpan_tuan_rumah"],
        akurasiUmpanTamu: json["akurasi_umpan_tamu"],
        pelanggaranTuanRumah: json["pelanggaran_tuan_rumah"],
        pelanggaranTamu: json["pelanggaran_tamu"],
        kartuKuningTuanRumah: json["kartu_kuning_tuan_rumah"],
        kartuKuningTamu: json["kartu_kuning_tamu"],
        kartuMerahTuanRumah: json["kartu_merah_tuan_rumah"],
        kartuMerahTamu: json["kartu_merah_tamu"],
        offsideTuanRumah: json["offside_tuan_rumah"],
        offsideTamu: json["offside_tamu"],
        cornerTuanRumah: json["corner_tuan_rumah"],
        cornerTamu: json["corner_tamu"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "jenis_pertandingan": jenisPertandingan,
        "tim_tuan_rumah": timTuanRumah,
        "tim_tamu": timTamu,
        "bendera_tuan_rumah": benderaTuanRumah,
        "bendera_tamu": benderaTamu,
        "tanggal": tanggal,
        "stadion": stadion,
        "skor_tuan_rumah": skorTuanRumah,
        "skor_tamu": skorTamu,
        "pencetak_gol_tuan_rumah": pencetakGolTuanRumah,
        "pencetak_gol_tamu": pencetakGolTamu,
        "starter_tuan_rumah": starterTuanRumah,
        "starter_tamu": starterTamu,
        "pengganti_tuan_rumah": penggantiTuanRumah,
        "pengganti_tamu": penggantiTamu,
        "manajer_tuan_rumah": manajerTuanRumah,
        "manajer_tamu": manajerTamu,
        "highlight": highlight,
        "penguasaan_bola_tuan_rumah": penguasaanBolaTuanRumah,
        "penguasaan_bola_tamu": penguasaanBolaTamu,
        "tembakan_tuan_rumah": tembakanTuanRumah,
        "tembakan_tamu": tembakanTamu,
        "on_target_tuan_rumah": onTargetTuanRumah,
        "on_target_tamu": onTargetTamu,
        "akurasi_umpan_tuan_rumah": akurasiUmpanTuanRumah,
        "akurasi_umpan_tamu": akurasiUmpanTamu,
        "pelanggaran_tuan_rumah": pelanggaranTuanRumah,
        "pelanggaran_tamu": pelanggaranTamu,
        "kartu_kuning_tuan_rumah": kartuKuningTuanRumah,
        "kartu_kuning_tamu": kartuKuningTamu,
        "kartu_merah_tuan_rumah": kartuMerahTuanRumah,
        "kartu_merah_tamu": kartuMerahTamu,
        "offside_tuan_rumah": offsideTuanRumah,
        "offside_tamu": offsideTamu,
        "corner_tuan_rumah": cornerTuanRumah,
        "corner_tamu": cornerTamu,
    };
}
