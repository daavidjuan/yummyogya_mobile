// lib/wishlist/screens/wishlist_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/wishlist_product.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<WishlistProduct> wishlistProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlistProducts();
  }

  Future<void> fetchWishlistProducts() async {
    try {
      // Di dalam fetchWishlistProducts()
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/wishlist/wishlist/json/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as List<dynamic>;
        setState(() {
          wishlistProducts = body.map((item) => WishlistProduct.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        // Handle error
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load wishlist: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Handle network error
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _removeFromWishlist(int foodId) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/wishlist/wishlist/remove-from-wishlist/$foodId/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Tambahkan header autentikasi jika diperlukan
        },
      );

      if (response.statusCode == 200) {
        // Refresh wishlist setelah menghapus
        fetchWishlistProducts();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil menghapus dari wishlist')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist Makanan'),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : wishlistProducts.isEmpty
          ? const Center(
              child: Text(
                'Wishlist Kosong',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: wishlistProducts.length,
              itemBuilder: (context, index) {
                final product = wishlistProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(
                      product.gambar,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported);
                      },
                    ),
                    title: Text(
                      product.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga: Rp ${product.harga}'),
                        Text('Rating: ${product.rating}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFromWishlist(product.id),
                    ),
                    onTap: () {
                      // Tambahkan navigasi ke detail produk jika diperlukan
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(product.nama),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                product.gambar,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 10),
                              Text('Deskripsi: ${product.deskripsi}'),
                              Text('Harga: Rp ${product.harga}'),
                              Text('Rating: ${product.rating}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}