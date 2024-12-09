import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:yummyogya_mobile/screens/login.dart';
import 'package:yummyogya_mobile/screens/menu.dart';
import 'package:yummyogya_mobile/screens/search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Yummyogya',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(secondary: Colors.deepPurple[400]),
        ),
        home: const LoginPage(),
        routes: {
          '/menu': (context) =>
              const MyHomePage(username: 'User'), // Rute ke halaman menu
          '/search': (context) => const SearchPage(username: 'User'),
          // Rute ke halaman search
          // '/wishlist' : (context) => const WishlistPage(),
          // '/dashboard' (context) => const DashboardPage(),
        },
      ),
    );
  }
}
