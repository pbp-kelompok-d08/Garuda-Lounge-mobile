import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/screens/menu.dart';
import 'package:garuda_lounge_mobile/screens/register.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

const Color red = Color(0xFFAA1515);     // Primary: #AA1515
const Color white = Color(0xFFFFFFFF);   // Secondary: #FFFFFF
const Color cream = Color(0xFFE7E3DD);   // Background/Surface: #E7E3DD
const Color black = Color(0xFF111111);
const Color gray = Color(0xFF374151);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        iconTheme: const IconThemeData(color: red),
        title: const Text(
          'Garuda Lounge',
          style: TextStyle(
            color: red,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate ke halaman register
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ),
              );
            },
            child: const Text(
              'Register',
              style: TextStyle(color: red),
            ),
          ),
          TextButton(
            onPressed: () {
              // Sudah di halaman login, jadi tidak perlu apa-apa
            },
            child: const Text(
              'Login',
              style: TextStyle(color: red),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420, // biar mirip card di web
            ),
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              shadowColor: Theme.of(context).colorScheme.primary,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 28.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: const [
                          Text(
                            'Selamat Datang Kembali',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: red,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Masuk ke akun kamu di GarudaLounge',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    const Text(
                      'Username',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan username',
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 10.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password',
                        filled: true,
                        fillColor: const Color(0xFFF9FAFB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 10.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () async {
                          String username = _usernameController.text;
                          String password = _passwordController.text;

                          // Check credentials
                          // TODO: Change the URL and don't forget to add trailing slash (/) at the end of URL!
                          // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
                          // If you using chrome,  use URL http://localhost:8000
                          final response = await request
                              .login("http://localhost:8000/auth/login/", {
                            'username': username,
                            'password': password,
                          });

                          if (request.loggedIn) {
                            String message = response['message'];
                            String uname = response['username'];
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHomePage(),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content:
                                    Text("$message Selamat datang, $uname."),
                                  ),
                                );
                            }
                          } else {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Login Failed'),
                                  content: Text(response['message']),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: red,
                          foregroundColor: white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24.0),
                    const Divider(),
                    const SizedBox(height: 12.0),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Belum punya akun? ',
                            style: TextStyle(color: gray),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Daftar Sekarang',
                              style: TextStyle(
                                color: red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}