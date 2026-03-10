import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/box_provider.dart';
import 'providers/book_provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const AramArchiveApp());
}

class AramArchiveApp extends StatelessWidget {
  const AramArchiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BoxProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: MaterialApp(
        title: 'Aram Archive',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1565C0),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            shape: StadiumBorder(),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
