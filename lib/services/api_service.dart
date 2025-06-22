import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/product.dart';
import '../models/category.dart';

class ApiService {
  static String? _baseUrl = dotenv.env['API_BASE_URL'];
  static const String _productsEndpoint = 'products';
  static const String _categoriesEndpoint = 'categories';
  static const String _salesEndpoint = 'sales';

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/$_productsEndpoint'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/$_categoriesEndpoint'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<Product> getProductDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$_productsEndpoint/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product details');
    }
  }

  static Future<Product> createProduct(Map<String, dynamic> productData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$_productsEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product');
    }
  }
}