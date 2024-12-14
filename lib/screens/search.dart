import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:yummyogya_mobile/models/makanan_entry.dart';
import 'package:yummyogya_mobile/screens/detail_makanan.dart';
import 'package:yummyogya_mobile/screens/menu.dart';
import 'package:yummyogya_mobile/widgets/left_drawer.dart';
import 'package:yummyogya_mobile/widgets/bottom_nav.dart';

class SearchPage extends StatefulWidget {
  final String username;
  const SearchPage({Key? key, required this.username}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<Makanan>> fetchMakanan(CookieRequest request) async {
    const String url = 'http://127.0.0.1:8000/json/';
    final response = await request.get(url);

    var data = response;

    List<Makanan> listMakanan = [];
    for (var d in data) {
      if (d != null) {
        listMakanan.add(Makanan.fromJson(d));
      }
    }
    return listMakanan;
  }

  int _currentIndex = 1; // Indeks untuk Search
  String searchQuery = ""; // Query pencarian makanan
  late Future<List<Makanan>> makananFuture; // Data makanan dari server

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    makananFuture = fetchMakanan(request); // Ambil data makanan saat init
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0: // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(username: widget.username),
          ),
        );
        break;
      case 1: // Search
        // Tetap di halaman ini
        break;
      case 2: // Profile
        // Tambahkan navigasi ke ProfilePage
        break;
      case 3: // Article
        // Tambahkan navigasi ke ArticlePage
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Makanan'),
        backgroundColor: Colors.orange,
      ),
      drawer: LeftDrawer(username: widget.username),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari makanan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery =
                      value.toLowerCase().trim(); // Update query pencarian
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: makananFuture,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada data makanan.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                // Filter makanan berdasarkan query pencarian
                final List<Makanan> allMakanan = snapshot.data as List<Makanan>;
                final List<Makanan> makananList = searchQuery.isEmpty
                    ? allMakanan
                    : allMakanan.where((makanan) {
                        final namaMakanan = makanan.fields.nama.toLowerCase();
                        return namaMakanan.contains(searchQuery);
                      }).toList();

                if (makananList.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada makanan yang cocok dengan pencarian.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Jumlah kolom dalam grid
                    crossAxisSpacing: 16, // Jarak horizontal antar kolom
                    mainAxisSpacing: 16, // Jarak vertikal antar baris
                    childAspectRatio:
                        0.75, // Rasio tinggi-lebar untuk setiap card
                  ),
                  itemCount: makananList.length,
                  itemBuilder: (_, index) {
                    final Makanan makanan = makananList[index];
                    return SizedBox(
                      height: 250, // Tinggi tetap untuk card
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Gambar makanan
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                              child: Image.network(
                                makanan.fields.gambar.startsWith('http')
                                    ? makanan.fields.gambar
                                    : 'http://127.0.0.1:8000${makanan.fields.gambar}',
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    height: 120,
                                    width: double.infinity,
                                    child: const Icon(
                                      Icons.fastfood,
                                      size: 60,
                                      color: Colors.orange,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Nama makanan
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                makanan.fields.nama,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Harga makanan
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Rp ${makanan.fields.harga}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Restoran makanan
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Restoran: ${makanan.fields.restoran}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Rating makanan
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 16, color: Colors.orange),
                                  const SizedBox(width: 4),
                                  Text(
                                    makanan.fields.rating,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),

                            // Tombol Add to Wishlist dan Detail
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              '${makanan.fields.nama} ditambahkan ke Wishlist!'),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      minimumSize: const Size(50, 30),
                                    ),
                                    child: const Text(
                                      'Wishlist',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailPage(makanan: makanan),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      minimumSize: const Size(50, 30),
                                    ),
                                    child: const Text(
                                      'Detail',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
