import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yummyogya_mobile/profilepage/models/profile_header.dart';
import 'package:yummyogya_mobile/profilepage/models/review_list.dart';
import 'package:yummyogya_mobile/profilepage/models/wishlist_list.dart';
import 'package:yummyogya_mobile/widgets/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> profileData = {};
  bool isLoading = true;
  String searchQuery = '';
  final int _currentIndex = 3;
  String filter = 'all';
  final String baseUrl = 'http://127.0.0.1:8000';

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/profilepage/profile/api/?username=${widget.username}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          profileData = data['data'];
          isLoading = false;
        });
      } else {
        showError('Gagal memuat data profil.');
      }
    } catch (error) {
      showError('Terjadi kesalahan: $error');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    setState(() {
      isLoading = false;
    });
  }

  void _navigateToPage(int index) {
    final routes = [
        () => Navigator.pushNamed(context, '/home'),
        () => Navigator.pushNamed(context, '/search'),
        () => Navigator.pushNamed(context, '/wishlist'),
        () => Navigator.pushNamed(context, '/profile'),
    ];

    if (index != _currentIndex) {
      routes[index]();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          profileData.isNotEmpty
              ? 'Profile ${profileData['username']}'
              : 'Mencari data pengguna...',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : RefreshIndicator(
        onRefresh: fetchProfileData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(
                profileData: profileData,
                baseUrl: baseUrl,
                onProfileUpdated: fetchProfileData,
              ),
              const SizedBox(height: 16),
              WishlistList(
                wishlist: profileData['wishlist'] ?? [],
                username: profileData['username'],
              ),
              const SizedBox(height: 16),
              ReviewList(
                username: profileData['username'],
                reviews: profileData['reviews'] ?? [],
                searchQuery: searchQuery,
                filter: filter,
                onSearchChanged: (value) => setState(() {
                  searchQuery = value;
                }),
                onFilterChanged: (value) => setState(() {
                  filter = value ?? 'all';
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => _navigateToPage(index),
      ),
    );
  }
}
