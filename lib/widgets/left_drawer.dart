import 'package:flutter/material.dart';
import 'package:yummyogya_mobile/dashboard/screens/dashboard_screen.dart';

import 'package:http/http.dart' as http;
import 'package:yummyogya_mobile/screens/article.dart';
import 'dart:convert';
import 'package:yummyogya_mobile/screens/login.dart';
import 'package:yummyogya_mobile/wishlist/screens/wishlist_screens.dart';

class LeftDrawer extends StatelessWidget {
  final String username; // Parameter untuk nama pengguna

  const LeftDrawer({Key? key, required this.username}) : super(key: key);

  // Fungsi logout
  Future<void> logout(BuildContext context) async {
    const String logoutUrl =
        'http://127.0.0.1:8000/authentication/logout_flutter/';

    try {
      final response = await http.post(Uri.parse(logoutUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );

          // Navigasi ke halaman login setelah logout
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Logout gagal: ${data['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.orange,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Ganti dengan gambar profil
                ),
                const SizedBox(height: 10),
                Text(
                  'Selamat Datang, $username!', // Menampilkan nama pengguna
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Cari Makanan'),
            onTap: () {
              Navigator.pushNamed(
                  context, '/search'); // Route ke halaman Cari Makanan
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profil'),
            onTap: () {
              Navigator.pushNamed(
                  context, '/editProfile'); // Route ke halaman Edit Profil
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(username: username),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Wishlist'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WishlistScreen(username: username),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('Article'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArticleEntryPage(),
                ),
              );
            },
          ),

          // Divider
          const Divider(),

          // Back to Homepage
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Kembali ke Homepage'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/menu', // Route ke homepage (landing page)
                (route) => false, // Menghapus semua rute sebelumnya
              );
            },
          ),

          // Logout Option
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await logout(context);
            },
          ),
        ],
      ),
    );
  }
}
