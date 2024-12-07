import 'package:flutter/material.dart';
import 'add_food_screen.dart'; // Halaman untuk menambah makanan
import 'edit_food_screen.dart'; // Halaman untuk edit makanan

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> foods = []; // List untuk menampung data makanan
  bool isAscending = true; // Default sorting order
  String sortBy = 'name'; // Default sorting by name

  // Fungsi untuk menambahkan makanan baru ke dalam list
  void _addFood(Map<String, dynamic> newFood) {
    setState(() {
      foods.add(newFood); // Menambahkan makanan baru ke list
    });
  }

  // Fungsi untuk menghapus makanan berdasarkan index
  void _removeFood(int index) {
    setState(() {
      foods.removeAt(index); // Menghapus makanan berdasarkan index
    });
  }

  // Fungsi untuk mengedit makanan
  void _editFood(int index, Map<String, dynamic> updatedFood) {
    setState(() {
      foods[index] = updatedFood; // Mengupdate data makanan di list
    });
  }

  // Fungsi untuk mengurutkan makanan
  void _sortFoods() {
    setState(() {
      foods.sort((a, b) {
        int comparison;
        if (sortBy == 'name') {
          comparison = a['name'].compareTo(b['name']);
        } else {
          comparison = a['price'].compareTo(b['price']);
        }
        return isAscending ? comparison : -comparison;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Kamu'),
      ),
      body: Column(
        children: [
          // Tombol tambah makanan
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                // Navigasi ke halaman AddFoodScreen saat tombol ditekan
                final newFood = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFoodScreen()),
                );
                if (newFood != null) {
                  _addFood(newFood); // Menambahkan makanan baru ke list
                }
              },
              child: const Text('Tambah Makanan Baru'),
            ),
          ),
          // Opsi sorting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dropdown untuk memilih sorting by
                DropdownButton<String>(
                  value: sortBy,
                  items: const [
                    DropdownMenuItem(
                        value: 'name', child: Text('Sort by Name')),
                    DropdownMenuItem(
                        value: 'price', child: Text('Sort by Price')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        sortBy = value;
                        _sortFoods(); // Perbarui sorting
                      });
                    }
                  },
                ),
                // Toggle ascending/descending
                IconButton(
                  icon: Icon(
                    isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  ),
                  onPressed: () {
                    setState(() {
                      isAscending = !isAscending;
                      _sortFoods(); // Perbarui sorting
                    });
                  },
                ),
              ],
            ),
          ),
          // List makanan dalam grid
          Expanded(
            child: foods.isEmpty
                ? Center(
                    child: const Text('Belum ada makanan di dashboard'),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 3 / 4,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  food['image_url'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.restaurant, size: 16),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          food['restaurant'],
                                          style: const TextStyle(fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    food['description'],
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          size: 16, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${food['rating']} / 5',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    final updatedFood = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditFoodScreen(food: food),
                                      ),
                                    );
                                    if (updatedFood != null) {
                                      _editFood(index, updatedFood);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _removeFood(index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
