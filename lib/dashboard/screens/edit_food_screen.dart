// import 'package:flutter/material.dart';
// import 'dashboard_screen.dart'; // Adjust the path to the correct file

// class EditFoodScreen extends StatefulWidget {
//   final dynamic food;
//   EditFoodScreen({required this.food});

//   @override
//   _EditFoodScreenState createState() => _EditFoodScreenState();
// }

// class _EditFoodScreenState extends State<EditFoodScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _priceController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _categoryController;
//   late TextEditingController _restaurantController;
//   late TextEditingController _ratingController;
//   late TextEditingController _imageUrlController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(
//         text: widget.food.name); // Ubah menjadi widget.food.name
//     _priceController =
//         TextEditingController(text: widget.food.price.toString());
//     _descriptionController =
//         TextEditingController(text: widget.food.description);
//     _categoryController = TextEditingController(text: widget.food.kategori);
//     _restaurantController = TextEditingController(text: widget.food.restoran);
//     _ratingController = TextEditingController(text: widget.food.rating);
//     _imageUrlController = TextEditingController(text: widget.food.imageUrl);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Makanan'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Input untuk Nama Makanan
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Nama Makanan'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Nama makanan tidak boleh kosong';
//                   }
//                   return null;
//                 },
//               ),
//               // Input untuk Harga
//               TextFormField(
//                 controller: _priceController,
//                 decoration: const InputDecoration(labelText: 'Harga'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Harga tidak boleh kosong';
//                   }
//                   final price = int.tryParse(value);
//                   if (price == null || price <= 0) {
//                     return 'Harga harus lebih besar dari 0';
//                   }
//                   return null;
//                 },
//               ),
//               // Input untuk Deskripsi
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(labelText: 'Deskripsi'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Deskripsi tidak boleh kosong';
//                   }
//                   return null;
//                 },
//               ),
//               // Input untuk Kategori
//               TextFormField(
//                 controller: _categoryController,
//                 decoration: const InputDecoration(labelText: 'Kategori'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Kategori tidak boleh kosong';
//                   }
//                   return null;
//                 },
//               ),
//               // Input untuk Nama Restoran
//               TextFormField(
//                 controller: _restaurantController,
//                 decoration: const InputDecoration(labelText: 'Nama Restoran'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Nama restoran tidak boleh kosong';
//                   }
//                   return null;
//                 },
//               ),
//               // Input untuk Rating
//               TextFormField(
//                 controller: _ratingController,
//                 decoration: const InputDecoration(labelText: 'Rating (0 - 5)'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Rating tidak boleh kosong';
//                   }
//                   final rating = double.tryParse(value);
//                   if (rating == null || rating < 0 || rating > 5) {
//                     return 'Rating harus antara 0 dan 5';
//                   }
//                   return null;
//                 },
//               ),
//               // Input untuk URL Gambar
//               TextFormField(
//                 controller: _imageUrlController,
//                 decoration: const InputDecoration(labelText: 'URL Gambar'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'URL Gambar tidak boleh kosong';
//                   }
//                   final uri = Uri.tryParse(value);
//                   if (uri == null || !uri.hasAbsolutePath) {
//                     return 'URL tidak valid';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               // Tombol Perbarui
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // Membuat objek FoodEntry yang telah diperbarui
//                     final updatedFood = FoodEntry(
//                       id: widget.food.id, // ID tetap sama
//                       name: _nameController.text,
//                       description: _descriptionController.text,
//                       price: int.parse(_priceController.text),
//                       imageUrl: _imageUrlController.text,
//                       restoran: _restaurantController.text,
//                       kategori: _categoryController.text,
//                       rating: _ratingController.text,
//                     );

//                     // Mengirim kembali objek yang sudah diperbarui ke halaman sebelumnya
//                     Navigator.pop(context, updatedFood);

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Data Makanan Diperbarui')),
//                     );
//                   }
//                 },
//                 child: const Text('Perbarui Makanan'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '/dashboard/models/food_entry.dart'; // Import model FoodEntry yang sudah dibuat

class EditFoodScreen extends StatefulWidget {
  final FoodEntry food;

  EditFoodScreen({required this.food});

  @override
  State<EditFoodScreen> createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, description, imageUrl, restoran, kategori, rating;
  late int price;

  @override
  void initState() {
    super.initState();
    name = widget.food.name;
    description = widget.food.description;
    imageUrl = widget.food.imageUrl;
    restoran = widget.food.restoran;
    kategori = widget.food.kategori;
    rating = widget.food.rating;
    price = widget.food.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Food')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Food Name'),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
              ),
              TextFormField(
                initialValue: imageUrl,
                decoration: InputDecoration(labelText: 'Image URL'),
                onChanged: (value) => imageUrl = value,
              ),
              TextFormField(
                initialValue: restoran,
                decoration: InputDecoration(labelText: 'Restaurant'),
                onChanged: (value) => restoran = value,
              ),
              TextFormField(
                initialValue: kategori,
                decoration: InputDecoration(labelText: 'Category'),
                onChanged: (value) => kategori = value,
              ),
              TextFormField(
                initialValue: rating,
                decoration: InputDecoration(labelText: 'Rating'),
                onChanged: (value) => rating = value,
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = int.tryParse(value) ?? 0,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedFood = FoodEntry(
                      id: widget.food.id,
                      name: name,
                      description: description,
                      price: price,
                      imageUrl: imageUrl,
                      restoran: restoran,
                      kategori: kategori,
                      rating: rating,
                    );
                    Navigator.pop(context, updatedFood);
                  }
                },
                child: Text('Update Food'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
