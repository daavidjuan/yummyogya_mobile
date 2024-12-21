import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:yummyogya_mobile/dashboard/screens/dashboard_screen.dart';
import 'package:yummyogya_mobile/screens/article.dart';
import 'package:yummyogya_mobile/screens/login.dart';
import 'package:yummyogya_mobile/screens/menu.dart';
import 'package:yummyogya_mobile/screens/search.dart';
import 'package:yummyogya_mobile/wishlist/screens/wishlist_screens.dart';
import 'package:yummyogya_mobile/profilepage/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        title: 'Yummyogya',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(secondary: Colors.deepPurple[400]),
        ),
        // Periksa status login dan arahkan ke halaman yang sesuai
        home: Consumer<CookieRequest>(
          builder: (context, request, child) {
            // Jika user sudah login, arahkan ke MyHomePage
            return request.loggedIn
                ? const MyHomePage(
                    username: 'User') // Ganti dengan username dinamis jika ada
                : const LoginPage(); // Jika belum login, tetap ke LoginPage
          },
        ),
        routes: {
          '/menu': (context) => const MyHomePage(username: 'User'),
          '/search': (context) => const SearchPage(username: 'User'),
          '/wishlist': (context) => const WishlistScreen(username: 'User'),
          '/article': (context) => const ArticleEntryPage(),
          '/dashboard': (context) => DashboardScreen(username: 'User'),
          '/profile': (context) => ProfileScreen(username: 'User'),
        },
      ),
    );
  }
}
