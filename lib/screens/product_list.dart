import 'package:flutter/material.dart';
import 'package:posapp/models/category.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import 'product_detail.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;
  late Future<List<Category>> futureCategories;
  List<Product> products = [];
  List<Category> categories = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService.getProducts();
    futureCategories = ApiService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                futureProducts = ApiService.getProducts();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          }

          products = snapshot.data!;

          return Column(
            children: [
              FutureBuilder<List<Category>>(
                future: futureCategories,
                builder: (context, categorySnapshot) {
                  if (categorySnapshot.connectionState == ConnectionState.done &&
                      categorySnapshot.hasData) {
                    categories = categorySnapshot.data!;

                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        hint: Text('Filter by Category'),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Categories'),
                          ),
                          ...categories.map((category) {
                            return DropdownMenuItem(
                              value: category.id.toString(),
                              child: Text(category.name),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    if (selectedCategory != null &&
                        product.categoryId.toString() != selectedCategory) {
                      return SizedBox.shrink();
                    }

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          'Stock: ${product.stock} | Price: \$${product.sellingPrice}',
                        ),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(productId: product.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigate to add product screen
        },
      ),
    );
  }
}