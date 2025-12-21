# Garuda Lounge

## Deskripsi Aplikasi
Deskripsi mengenai Aplikasi yang akan kami buat yang bernama Garuda Lounge. 
Aplikasi yang kelompok kami buat bernama Garuda Lounge, yaitu sebuah fansite untuk Tim Nasional (Timnas) Sepak Bola Indonesia. Tujuan utama website ini adalah untuk menjadi wadah bagi para penggemar Timnas agar bisa mendapatkan berbagai informasi dan update terbaru seputar dunia sepak bola Indonesia, terutama yang berkaitan dengan Timnas baik dari segi berita, profil pemain, merchandise resmi, maupun sejarah pemain legendaris.

## Fitur Aplikasi
Melalui Garuda Lounge, pengguna bisa:
1. Melihat profil dan deskripsi umum Timnas Indonesia.
2. Membaca berita terbaru seputar pertandingan dan aktivitas pemain.
3. Melihat daftar pertandingan dan hasilnya.
4. Menjelajahi katalog merchandise yang tersedia.
5. Mengenal lebih dekat para pemain legendaris yang pernah membela Timnas.
yang dimana aplikasi ini akan dibangun menggunakan Django sebagai backend framework, serta memanfaatkan konsep modular apps untuk memisahkan setiap fitur utama.

## Nama Anggota Kelompok dan Pembagian Modul

| No	| Nama	                    |    NPM	 | Tugas/Modul |
| :---: | :--- | :--- | :--- |
| 1	| Sausan Farah Azzahra	    | 2406439091 | Modul Profil/Deskripsi Timnas
| 2	| Deslee Jever Phillipa     | 2406433560 | Modul Artikel/Berita
| 3	| Tiara Widyaningrum        | 2406431100 | Modul Profil Pemain Legend
| 4	| Dzaky Ahmad Trinindito    | 2406406351 | Modul Merchandise
| 5	|	Muhammad Farrel Rajendra  | 2406495653 | Modul Match

## Modul yang Diimplementasikan
  * ### Profil/Deskripsi Timnas
Menampilkan informasi umum tentang Timnas Indonesia seperti sejarah singkat, pelatih, prestasi, dan struktur tim.
Modul ini juga menjadi halaman utama yang memperkenalkan aplikasi kepada pengguna.
  * ### Pertandingan (Match)
Berisi daftar pertandingan Timnas, baik yang sudah berlangsung maupun yang akan datang.
Informasi mencakup lawan, skor, tanggal pertandingan, dan lokasi.
Admin bisa menambahkan atau memperbarui jadwal pertandingan.
  * ###  Artikel/Berita
Menampilkan berita terbaru seputar Timnas Indonesia seperti hasil pertandingan, transfer pemain, atau wawancara eksklusif.
Pengguna biasa bisa membaca dan memberikan komentar pada berita.
  * ### Merchandise
Modul ini menampilkan daftar produk resmi Timnas (seperti jersey, jaket, atau aksesori).
Pengguna bisa melihat detail produk dan menambahkannya ke wishlist (atau keranjang, jika nanti dikembangkan ke tahap payment).
  * ### Profil Pemain Legend
Menampilkan informasi tentang pemain-pemain legendaris yang pernah membela Timnas Indonesia.
Setiap pemain akan punya halaman profil sendiri berisi biografi singkat dan pencapaian kariernya.

## Deskripsi Role Pengguna
Aplikasi kami memiliki satu jenis pengguna yaitu user biasa (Pengunjung) yang
dapat membaca berita, melihat profil pemain dan merchandise, memberikan komentar pada artikel, serta memiliki akses untuk mengubah data di aplikasi.

## Alur Pengintegrasian Data di Aplikasi Mobile Dengan Aplikasi Web (PWS)  
### 1. Mengaktifkan CORS  
* Menambahkan `django-cors-headers` ke `requirements.txt` yang ada di proyek Django.
* Menginstall library `corsheaders`:
 ```css
 pip install django-cors-headers
```
* Menambahkan `corsheaders` ke `INSTALLED_APPS` di `settings.py` di proyek Django.
* Menambahkan `corsheaders.middleware.CorsMiddleware` ke `MIDDLEWARE` di `settings.py` di proyek Django.
* Menambahkan variabel-variabel ini di `settings.py` di proyek Django untuk mengaktifkan akses lintas-domain (CORS), tepi tetap memastikan keamanan cookie lewat penggunaan HTTPS dan memungkinkan cookie session dan CSRF ditransmisikan saat dibutuhkan dari domain luar (dengan `Samesite='None'`).
```css
CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True
CSRF_COOKIE_SECURE = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SAMESITE = 'None'
SESSION_COOKIE_SAMESITE = 'None'
```
* Menambahkan alamat `10.0.2.2` di `ALLOWD_HOSTS` di `settings.py` untuk keperluan integrasi ke Django dari emulator Android

### 2. Membuat Model Dart Untuk Masing-masing Model di Django
* Buka endpoint `JSON` dari masing-masing model di Django untuk mendapat data dari model tersebut.
* Format data `JSON` tersebut ke bahasa Dart.
* method `fromJson` untuk mengubah JSON dari Django menjadi objek Dart dan method `toJson` untuk mengubah objek Dart menjadi JSON saat dikirim balik ke Django
* Buat file untuk masing-masing model Dart yang ingin dibuat.
* Letakkan data `JSON` yang sudah diformat ke file untuk masing-masing model Dart.
    
### 3. Menerapkan Fetch Data dari Django Untuk Ditampilkan ke Flutter
* Menambahkan package http untuk proyek Flutter dengan menjalankan command ini di terminal proyek Flutter:
```css
flutter pub add http
```
* Memperbolehkan akses internet pada aplikasi Flutter dengan menambahkan `<uses-permission android:name="android.permission.INTERNET" />`  di `android/app/src/main/AndroidManifest.xml`
* Menambahkan endpoint proxy untuk mengatasi masalah CORS untuk gambar (ini dilakuakn di `setting.py` proyek Django).
* Buat fungsi asinkronus untuk fetch data dari masing-maisng model Django.
* Menampilkan data di UI dengan cara menghubngkan fungsi fetch data dengan tampilan layar menggunakan `FutureBuilder` 

## Link APK dan Desain FIGMA
[![Build Status](https://app.bitrise.io/app/6e661066-144f-4b0a-8308-bac1a2489d78/status.svg?token=DYOLZ44hHOCzq5jh__Hg-w&branch=master)](https://app.bitrise.io/app/6e661066-144f-4b0a-8308-bac1a2489d78)
Link APK : https://app.bitrise.io/app/6e661066-144f-4b0a-8308-bac1a2489d78/installable-artifacts/46311490dd40edce/public-install-page/2e28653648e86087ac163ee917882bd1 (deadline)   

Link APK : https://app.bitrise.io/app/6e661066-144f-4b0a-8308-bac1a2489d78/installable-artifacts/9eb842218c086645/public-install-page/c45324ec3c34ad6c8d969101c741c8c4 (setelah deadline karena kami lupa ganti localhost jadi pws)  

Link FIGMA : https://www.figma.com/design/XNzG0SDEzs3QQ7SuMVuUoC/GarudaLounge?node-id=0-1&t=Dey5VhTB4bqIc8u5-1 


semangaat
