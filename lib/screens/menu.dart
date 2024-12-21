import 'package:flutter/material.dart';
import 'package:yummyogya_mobile/widgets/left_drawer.dart';
import 'package:yummyogya_mobile/widgets/bottom_nav.dart';

class MyHomePage extends StatefulWidget {
  final String username;

  const MyHomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/menu');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/article');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YummyYogya'),
        backgroundColor: Colors.orange,
      ),
      drawer: LeftDrawer(username: widget.username),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Floating Container
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://www.google.com/url?sa=i&url=https%3A%2F%2Fareajogja.wordpress.com%2F2020%2F09%2F29%2Fobyek-wisata-sejarah-dan-budaya-di-yogyakarta%2F&psig=AOvVaw16U_xxNGhRsOr8nw8fNPCz&ust=1734837193981000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCNj3tLjyt4oDFQAAAAAdAAAAABAK'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        Text(
                          'YummyYogya',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Hadir membantu wisatawan dan masyarakat lokal menemukan makanan khas Yogyakarta.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Row of Icon Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Search Icon
                  _buildFeatureButton(
                    icon: Icons.search,
                    label: 'Search',
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    },
                  ),
                  // Wishlist Icon
                  _buildFeatureButton(
                    icon: Icons.favorite,
                    label: 'Wishlist',
                    onPressed: () {
                      Navigator.pushNamed(context, '/wishlist');
                    },
                  ),
                  // Article Icon
                  _buildFeatureButton(
                    icon: Icons.newspaper,
                    label: 'Article',
                    onPressed: () {
                      Navigator.pushNamed(context, '/article');
                    },
                  ),
                  // Dashboard Icon
                  _buildFeatureButton(
                    icon: Icons.dashboard,
                    label: 'Dashboard',
                    onPressed: () {
                      Navigator.pushNamed(context, '/dashboard');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Additional Content (if any)
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  // Helper Widget for Feature Buttons
  Widget _buildFeatureButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.orange,
          ),
          onPressed: onPressed,
          child: Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
