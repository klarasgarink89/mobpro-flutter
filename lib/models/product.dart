class Product {
  final int id;
  final int categoryId;
  final String code;
  final String name;
  final String? brand;
  final int purchasePrice;
  final int discount;
  final int sellingPrice;
  final int stock;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.categoryId,
    required this.code,
    required this.name,
    this.brand,
    required this.purchasePrice,
    required this.discount,
    required this.sellingPrice,
    required this.stock,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_produk'],
      categoryId: json['id_kategori'],
      code: json['kode_produk'],
      name: json['nama_produk'],
      brand: json['merk'],
      purchasePrice: json['harga_beli'],
      discount: json['diskon'],
      sellingPrice: json['harga_jual'],
      stock: json['stok'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}