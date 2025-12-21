import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class UserProvider extends ChangeNotifier {
  bool _isStaff = false;
  String _username = "";
  
  // flag agar kita tidak fetch berulang-ulang jika data sudah ada
  bool _isDataFetched = false;

  // getter agar variabel bisa dibaca dari luar
  bool get isStaff => _isStaff;
  String get username => _username;
  bool get isDataFetched => _isDataFetched;

  // fungsi untuk reset data (dipanggil saat logout)
  void logout() {
    _isStaff = false;
    _username = "";
    _isDataFetched = false;
    notifyListeners(); // memberitahu semua widget bahwa data berubah
  }

  // mengambil status user dari Django
  Future<void> fetchUserStatus(CookieRequest request) async {
    // ga perlu return apa apa kalau data udah pernah diambil
    if (_isDataFetched) return;

    try {
      final response = await request.get('https://muhammad-farrel46-garudalounge.pbp.cs.ui.ac.id/auth/status/');
      
      _isStaff = response['is_staff'] ?? false;
      _username = response['username'] ?? "Guest";
      _isDataFetched = true;

      // buat event untuk semua widget yang pakai fungsi ini
      notifyListeners(); 
      
    } catch (e) {
      // print("Gagal mengambil status user: $e");
    }
  }
}