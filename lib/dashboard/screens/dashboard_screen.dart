import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'edit_food_screen.dart';
import 'add_food_screen.dart'; // Import layar tambah makanan
import '/dashboard/models/food_entry.dart'; // Import model FoodEntry

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<FoodEntry>> _foodEntries;
  String _sortBy = 'Name';
  bool _ascending = true;

  @override
  void initState() {
    super.initState();
    _foodEntries = fetchFoodEntries();
  }

  Future<List<FoodEntry>> fetchFoodEntries() async {
    const String url = 'http://127.0.0.1:8000/dashboard/foods/';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<FoodEntry> foods =
            data.map((item) => FoodEntry.fromJson(item)).toList();

        foods.sort((a, b) {
          int comparison;
          if (_sortBy == 'Name') {
            comparison = a.name.compareTo(b.name);
          } else {
            comparison = a.price.compareTo(b.price);
          }
          return _ascending ? comparison : -comparison;
        });
        return foods;
      } else {
        throw Exception(
            "Failed to load foods. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error occurred: $e");
    }
  }

  Future<void> deleteFood(int id) async {
    const String url = 'http://127.0.0.1:8000/dashboard/foods/';

    try {
      final response = await http.delete(Uri.parse('$url$id/'));

      if (response.statusCode == 200) {
        setState(() {
          _foodEntries = fetchFoodEntries();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Makanan berhasil dihapus')),
        );
      } else {
        throw Exception(
            'Failed to delete food. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  void _addNewFood() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFoodScreen()),
    );
    if (result == true) {
      setState(() {
        _foodEntries =
            fetchFoodEntries(); // Perbarui data makanan setelah tambah
      });
    }
  }

  void _navigateToEditFoodScreen(FoodEntry food) async {
    final updatedFood = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFoodScreen(food: food),
      ),
    );

    if (updatedFood != null && updatedFood is FoodEntry) {
      setState(() {
        _foodEntries = fetchFoodEntries(); // Perbarui data setelah edit
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Dashboard"),
        actions: [
          DropdownButton<String>(
            value: _sortBy,
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
                _foodEntries = fetchFoodEntries();
              });
            },
            items: const [
              DropdownMenuItem(
                value: 'Name',
                child: Text('Sort by Name'),
              ),
              DropdownMenuItem(
                value: 'Price',
                child: Text('Sort by Price'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(_ascending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                _ascending = !_ascending;
                _foodEntries = fetchFoodEntries();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<FoodEntry>>(
        future: _foodEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No foods available"));
          }

          List<FoodEntry> foods = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // Menampilkan 5 card per baris
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 2 / 3, // Menentukan rasio ukuran card
            ),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              FoodEntry food = foods[index];

              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        child: Image.network(
                          food.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        food.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Price: \$${food.price}"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _navigateToEditFoodScreen(food),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteFood(food.id),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewFood,
        child: const Icon(Icons.add),
        tooltip: 'Tambah Makanan',
      ),
    );
  }
}
