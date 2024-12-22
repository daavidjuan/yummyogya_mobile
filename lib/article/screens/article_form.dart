import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:yummyogya_mobile/article/models/article_entry.dart';
import 'package:yummyogya_mobile/article/screens/article.dart';
import 'package:provider/provider.dart';


class ArticleFormPage extends StatefulWidget{
  final ArticleEntry? article;
  const ArticleFormPage({super.key, this.article});

  @override
  State<ArticleFormPage> createState() => _ArticleFormPageState();
}

class _ArticleFormPageState extends State<ArticleFormPage>{
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";
  String _imageUrl = "";
  final TextEditingController _imageUrlController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    if (widget.article != null) {
      _title = widget.article!.fields.title;
      _content = widget.article!.fields.content;
      _imageUrl = widget.article!.fields.imageUrl;
      _imageUrlController.text = _imageUrl;
    }
  }

  @override
  void dispose(){
    _imageUrlController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Form Artikel',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        )
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Judul Artikel',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Judul artikel tidak boleh kosong';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _title = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Isi Artikel',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Isi artikel tidak boleh kosong';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _content = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: 'URL Gambar',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'URL gambar tidak boleh kosong';
                    }
                    return null;
                  },
                  onChanged: (value){
                    setState(() {
                      _imageUrl = value;
                    });
                  },
                  onSaved: (value){
                    _imageUrl = value!;
                  },
                ),
              ),
              if (_imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    _imageUrl,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Invalid Image URL');
                    },
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final response = await request.postJson(
                          "http://127.0.0.1:8000/article/create-flutter/",
                          jsonEncode(<String, String>{
                            'title': _title,
                            'content': _content,
                            'image_url': _imageUrl,
                          }), 
                        );
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Artikel baru berhasil disimpan!"),
                            ));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const ArticleEntryPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text("Terdapat kesalahan, silakan coba lagi."),
                            ));
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}