import 'package:flutter/material.dart';

class EditFoodScreen extends StatefulWidget {
  final dynamic food;
  EditFoodScreen({required this.food});

  @override
  _EditFoodScreenState createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _restaurantController;
  late TextEditingController _ratingController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.food['name']);
    _priceController =
        TextEditingController(text: widget.food['price'].toString());
    _descriptionController =
        TextEditingController(text: widget.food['description']);
    _categoryController = TextEditingController(text: widget.food['category']);
    _restaurantController =
        TextEditingController(text: widget.food['restaurant']);
    _ratingController =
        TextEditingController(text: widget.food['rating'].toString());
    _imageUrlController = TextEditingController(text: widget.food['image_url']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Makanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input untuk Nama Makanan
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Makanan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama makanan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              // Input untuk Harga
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  final price = int.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Harga harus lebih besar dari 0';
                  }
                  return null;
                },
              ),
              // Input untuk Deskripsi
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              // Input untuk Kategori
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori tidak boleh kosong';
                  }
                  return null;
                },
              ),
              // Input untuk Nama Restoran
              TextFormField(
                controller: _restaurantController,
                decoration: const InputDecoration(labelText: 'Nama Restoran'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama restoran tidak boleh kosong';
                  }
                  return null;
                },
              ),
              // Input untuk Rating
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Rating (0 - 5)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Rating tidak boleh kosong';
                  }
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 0 || rating > 5) {
                    return 'Rating harus antara 0 dan 5';
                  }
                  return null;
                },
              ),
              // Input untuk URL Gambar
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL Gambar tidak boleh kosong';
                  }
                  final uri = Uri.tryParse(value);
                  if (uri == null || !uri.hasAbsolutePath) {
                    return 'URL tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Tombol Perbarui
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Simpan perubahan makanan ke database atau API
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Data Makanan Diperbarui')));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Perbarui Makanan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
