import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yummyogya_mobile/article/models/article_entry.dart';
import 'package:yummyogya_mobile/article/screens/article_detail.dart';
import 'package:yummyogya_mobile/article/screens/article_form.dart';
import 'package:yummyogya_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ArticleEntryPage extends StatefulWidget {
  const ArticleEntryPage({super.key});

  @override
  State<ArticleEntryPage> createState() => _ArticleEntryPageState();
}

class _ArticleEntryPageState extends State<ArticleEntryPage> {
  Future<List<ArticleEntry>> fetchArticle(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/article/json/');
    var data = response;

    List<ArticleEntry> articles = [];
    for (var d in data) {
      if (d != null) {
        try {
          articles.add(ArticleEntry.fromJson(d));
        } catch (e) {
          debugPrint('Error parsing article: $e');
        }
      }
    }
    return articles;
  }

  Future<void> deleteArticle(CookieRequest request, String id) async {
    try {
      final response = await request.postJson(
        'http://127.0.0.1:8000/article/delete-flutter/',
        jsonEncode({'id': id}),
      );
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Article deleted successfully!")),
        );
        setState(() {}); // Refresh data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Failed to delete article: ${response['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel YummYogya'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Back to Homepage',
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/menu');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ArticleFormPage()),
          ).then((_) {
            setState(() {}); // Refresh after adding
          });
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        tooltip: 'Add Article',
      ),
      body: FutureBuilder(
        future: fetchArticle(request),
        builder: (context, AsyncSnapshot<List<ArticleEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data artikel pada YummYogya.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final article = snapshot.data![index];
                final contentWords = article.fields.content.split(' ');
                final truncatedContent = contentWords.length > 20
                    ? '${contentWords.take(20).join(' ')}...'
                    : article.fields.content;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailPage(article: article),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            article.fields.imageUrl,
                            height: 100, // Adjusted height
                            width: 100, // Fixed width
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 50);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.fields.title,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Published on: ${article.fields.publishedDate}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(truncatedContent),
                            ],
                          ),
                        ),
                        // Tambahkan Tombol Edit dan Delete Jika Artikel Dibuat oleh Pengguna Saat Ini
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArticleFormPage(article: article),
                                  ),
                                ).then((_) {
                                  setState(() {}); // Refresh after editing
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Konfirmasi Penghapusan'),
                                      content: const Text('Apakah Anda yakin ingin menghapus artikel ini?'),
                                      actions: [
                                        TextButton(
                                          child: const Text('Batal'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            deleteArticle(request, article.pk.toString());
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}