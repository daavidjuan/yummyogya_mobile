import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:yummyogya_mobile/models/article_entry.dart';
import 'package:yummyogya_mobile/widgets/left_drawer.dart';

class ArticleEntryPage extends StatefulWidget {
  const ArticleEntryPage({super.key});

  @override
  State<ArticleEntryPage> createState() => _ArticleEntryPageState();
}

class _ArticleEntryPageState extends State<ArticleEntryPage> {
  Future<List<ArticleEntry>> fetchArticle(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/article/json/');
    List<ArticleEntry> articles = [];

    for (var article in response) {
      if (article != null) {
        articles.add(ArticleEntry.fromJson(article));
      }
    }
    return articles;
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const LeftDrawer(username: 'username'), // Sesuaikan dengan username Anda
      body: FutureBuilder<List<ArticleEntry>>(
        future: fetchArticle(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada artikel'));
          } else {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      article.fields.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    subtitle: Text(article.fields.content),
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