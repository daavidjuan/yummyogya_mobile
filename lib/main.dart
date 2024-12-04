import 'package:flutter/material.dart';
import 'package:yummyogya_mobile/screens/menu.dart';
import 'package:yummyogya_mobile/screens/search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ).copyWith(secondary: Colors.deepPurple[400]),
        useMaterial3: true,
      ),
      home: MyHomePage(),
      routes: {
        '/search': (context) => const SearchPage(), // Halaman pencarian makanan
        // '/edit_profile' : (context) => const
      },
    );
  }
}
