// lib/repositories/product_repository.dart
import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> getProductsByCategory(String category); // [추가]
  Future<List<Product>> searchProducts(String keyword);
  Future<List<Product>> getBestSellers();
  Future<void> addProduct(Product product);
}