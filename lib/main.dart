import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pustaka/views/components/book/index.dart';
import 'package:pustaka/views/home.dart';
import 'package:pustaka/views/widgets/login/index.dart';
import 'package:pustaka/data/services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pustaka Skarla',
        theme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
          useMaterial3: true,
        ),
        home: FutureBuilder<bool>(
          future: _authService.isAuthenticated(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (snapshot.hasData && snapshot.data == true) {
                return const HomePage();
              } else {
                return LoginScreen();
              }
            }
          },
        ),
        routes: {
          '/home': (context) => HomePage(),
          '/login': (context) => LoginScreen(),
          '/detail-book': (context) => BookPage()
        });
  }
}
