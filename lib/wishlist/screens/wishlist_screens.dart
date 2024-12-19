import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/wishlist_product.dart';
import 'dart:convert';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

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

  Future<void> fetchWishlistItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/wishlist/get_wishlist/'),
        headers: {
          'Content-Type': 'application/json',
          // Add your authentication headers here if needed
        },
      );

      if (response.statusCode == 200) {
        final List<WishlistProduct> items = wishlistProductFromJson(response.body);
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
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/wishlist/wishlist/remove-from-wishlist/$foodId/'),
        headers: {
          'Content-Type': 'application/json',
          // Add your authentication headers here if needed
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove item from wishlist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> updateNotes(int foodId, String notes) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/wishlist/wishlist/update-notes/$foodId/'),
        headers: {
          'Content-Type': 'application/json',
          // Add your authentication headers here if needed
        },
        body: jsonEncode({'notes': notes}),
      );

      if (response.statusCode == 200) {
        fetchWishlistItems(); // Refresh the list
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
        title: const Text('My Wishlist'),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        // Food Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
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
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rp ${item.harga}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  Text(item.rating),
                                ],
                              ),
                              if (item.notes.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Notes: ${item.notes}',
                                  style: Theme.of(context).textTheme.bodySmall,
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
                              icon: const Icon(Icons.delete),
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
    );
  }

  void _showNotesDialog(WishlistProduct item) {
    final TextEditingController notesController = TextEditingController(text: item.notes);

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