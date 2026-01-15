// lib/repositories/mock_product_repository.dart
import '../constants/data.dart';
import '../models/product.dart';
import 'product_repository.dart';

class MockProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return dummyProducts;
  }

  // [추가] 카테고리 필터링
  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return dummyProducts.where((p) => p.category == category).toList();
  }

  @override
  Future<List<Product>> getBestSellers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return dummyProducts;
  }

  @override
  Future<List<Product>> searchProducts(String keyword) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (keyword.isEmpty) return [];
    
    return dummyProducts.where((p) {
      String titleName = localizedValues['ko']?[p.titleKey] ?? p.titleKey;
      return titleName.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
  }

  @override
  Future<void> addProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 800));
    dummyProducts.insert(0, product); 
  }
}