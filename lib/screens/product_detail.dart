import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  ProductDetailScreen({required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = ApiService.getProductDetail(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: FutureBuilder<Product>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Product not found'));
          }

          final product = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 8.0),
                Text('Code: ${product.code}'),
                Text('Brand: ${product.brand ?? 'N/A'}'),
                Text('Category ID: ${product.categoryId}'),
                Divider(),
                Text(
                  'Pricing',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text('Purchase Price: \$${product.purchasePrice}'),
                Text('Selling Price: \$${product.sellingPrice}'),
                Text('Discount: ${product.discount}%'),
                Divider(),
                Text(
                  'Inventory',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text('Stock: ${product.stock}'),
              ],
            ),
          );
        },
      ),
    );
  }
}