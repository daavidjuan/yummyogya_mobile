import 'package:flutter/material.dart';
import 'package:yummyogya_mobile/article/models/article_entry.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleEntry article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.fields.title),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Artikel
            Center(
              child: Image.network(
                article.fields.imageUrl,
                height: 200, // Reduced height
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100);
                },
              ),
            ),
            const SizedBox(height: 16),
            // Judul Artikel
            Text(
              article.fields.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Isi Artikel
            Text(
              article.fields.content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}