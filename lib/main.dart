import 'package:bot_chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromRGBO(27, 31, 36, 0.85),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(27, 31, 36, 1),
          secondary: Color.fromRGBO(61, 60, 94, 1),
        ),
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.poppins(),
        ),
      ),
      home: const HomeScreen(),

    );
  }
}
