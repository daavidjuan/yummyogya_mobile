import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yummyogya_mobile/screens/menu.dart';
import 'package:yummyogya_mobile/screens/search.dart';
import '../models/wishlist_product.dart';
import 'dart:convert';

class WishlistScreen extends StatefulWidget {
  final String username;
  const WishlistScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<WishlistProduct> wishlistItems = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchWishlistItems();
  }

  void addToWishlist(WishlistProduct product) {
    setState(() {
      wishlistItems.add(product); // Tambahkan item ke daftar wishlist
    });
    fetchWishlistItems();
  }

  Future<void> _addToWishlist(Map<String, dynamic> wishlistData) async {
    final url =
        Uri.parse('http://127.0.0.1:8000/wishlist/add_wishlist_flutter/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(wishlistData),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse['message']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Item berhasil ditambahkan ke Wishlist! Total: ${jsonResponse['wishlist_count']}'),
            backgroundColor: Colors.green,
          ),
        );
        fetchWishlistItems();
      } else {
        print('Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan item ke Wishlist'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchWishlistItems() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1:8000/wishlist/wishlist/get_wishlist/?username=${widget.username}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<WishlistProduct> items =
            wishlistProductFromJson(response.body);
        setState(() {
          wishlistItems = items;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load wishlist items';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> removeFromWishlist(int foodId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'http://127.0.0.1:8000/wishlist/wishlist/remove-from-wishlist/$foodId/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          wishlistItems.removeWhere((item) => item.id == foodId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removed from wishlist')),
        );
      } else {
        final errorResponse = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to remove item: ${errorResponse['error']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> updateNotes(int foodId, String notes) async {
    final String url =
        'http://127.0.0.1:8000/wishlist/wishlist/update-notes/$foodId/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'notes': notes,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Perbarui catatan di list lokal
          final index = wishlistItems.indexWhere((item) => item.id == foodId);
          if (index != -1) {
            wishlistItems[index] = wishlistItems[index].copyWith(notes: notes);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notes updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update notes')),
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
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Text(error),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Wishlist',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(username: widget.username),
              ),
            ); // Navigasi kembali ke MyHomePage
          },
        ),
      ),
      body: wishlistItems.isEmpty
          ? const Center(
              child: Text('Your wishlist is empty'),
            )
          : ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Colors.orange, width: 1.5), // Outline oranye
                    borderRadius:
                        BorderRadius.circular(10), // Radius melengkung
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Food Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            item.gambar,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Food Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.nama,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87, // Font kekinian
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${item.harga}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.green, // Warna teks harga
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  Text(item.rating),
                                ],
                              ),
                              if (item.notes.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Notes: ${item.notes}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Actions
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showNotesDialog(item);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                removeFromWishlist(item.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(
                username: widget.username,
                addToWishlist: addToWishlist,
              ),
            ),
          );
        },
        label:
            const Text('Cari Makanan', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  void _showNotesDialog(WishlistProduct item) {
    final TextEditingController notesController =
        TextEditingController(text: item.notes);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Notes'),
        content: TextField(
          controller: notesController,
          decoration: const InputDecoration(
            hintText: 'Enter your notes here',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              updateNotes(item.id, notesController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}