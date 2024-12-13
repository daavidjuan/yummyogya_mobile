import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:yummyogya_mobile/models/makanan_entry.dart';
import 'package:yummyogya_mobile/widgets/left_drawer.dart';

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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Makanan'),
        backgroundColor: Colors.orange,
      ),
      drawer: LeftDrawer(username: widget.username),
      body: FutureBuilder(
        future: fetchMakanan(request),
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

          final List<Makanan> makananList = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Jumlah kolom dalam grid
              crossAxisSpacing: 16, // Jarak horizontal antar kolom
              mainAxisSpacing: 16, // Jarak vertikal antar baris
              childAspectRatio: 0.75, // Rasio tinggi-lebar untuk setiap card
            ),
            itemCount: makananList.length,
            itemBuilder: (_, index) {
              final Makanan makanan = makananList[index];
              return Card(
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

                    // Deskripsi makanan
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        makanan.fields.deskripsi,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Rating makanan
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
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
              );
            },
          );
        },
      ),
    );
  }
}

// Halaman Detail
class DetailPage extends StatelessWidget {
  final Makanan makanan;

  const DetailPage({Key? key, required this.makanan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(makanan.fields.nama),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              makanan.fields.gambar.startsWith('http')
                  ? makanan.fields.gambar
                  : 'http://127.0.0.1:8000${makanan.fields.gambar}',
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.fastfood,
                  size: 100,
                  color: Colors.orange,
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              makanan.fields.nama,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Rp ${makanan.fields.harga}'),
            const SizedBox(height: 8),
            Text('Rating: ${makanan.fields.rating}'),
            const SizedBox(height: 8),
            Text('Restoran: ${makanan.fields.restoran}'),
            const SizedBox(height: 8),
            Text(makanan.fields.deskripsi),
          ],
        ),
      ),
    );
  }
}
