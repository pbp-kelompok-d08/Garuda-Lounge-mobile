import 'package:flutter/material.dart';
import 'package:garuda_lounge_mobile/screens/login.dart';
import 'package:garuda_lounge_mobile/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Colors from the original code
    const Color red = Color(0xFFAA1515);     // Primary: #AA1515
    const Color white = Color(0xFFFFFFFF);   // Secondary: #FFFFFF
    const Color cream = Color(0xFFE7E3DD);   // Background/Surface: #E7E3DD
    const Color black = Color(0xFF111111);
    const Color gray = Color(0xFF374151);

    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Garuda Lounge Mobile',

        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.

          colorScheme: const ColorScheme.light(
            primary: red,
            secondary: white,
            surface: cream,
            onSurface: black,
            onSurfaceVariant: gray,
          ),

          scaffoldBackgroundColor: cream,
        ),

        home: const LoginPage(),
      ),
    );
  }
}
