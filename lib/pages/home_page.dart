// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../constants/data.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';
import '../repositories/mock_auth_repository.dart';
import '../widgets/coupang_header.dart';
import '../widgets/product_card.dart';
import 'search_page.dart';
import 'login_page.dart';

class ShoppingMainPage extends StatefulWidget {
  final ProductRepository productRepository;
  final MockAuthRepository authRepository;
  final String currentLang;
  final bool isLoggedIn;
  final bool isAdmin;
  final bool isSeller;
  final String userName;
  final Function(String) onLanguageChange;
  final Function(bool, bool, String) onLogin;
  final VoidCallback onLogout;
  final Function(String) tr;

  const ShoppingMainPage({
    super.key,
    required this.productRepository,
    required this.authRepository,
    required this.currentLang,
    required this.isLoggedIn,
    required this.isAdmin,
    required this.isSeller,
    required this.userName,
    required this.onLanguageChange,
    required this.onLogin,
    required this.onLogout,
    required this.tr,
  });

  @override
  State<ShoppingMainPage> createState() => _ShoppingMainPageState();
}

class _ShoppingMainPageState extends State<ShoppingMainPage> {
  // [수정] 현재 선택된 카테고리 (null이면 전체)
  String? _currentCategory;

  void _refreshProducts() {
    setState(() {
      _currentCategory = null; // 상품 등록 후엔 전체 목록 보기
    });
  }

  // [추가] 카테고리 선택 시 호출
  void _filterByCategory(String category) {
    setState(() {
      _currentCategory = category;
    });
  }

  void _goToSearchResult(String keyword) {
    if (keyword.trim().isEmpty) return;
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => SearchResultPage(
          productRepository: widget.productRepository, 
          currentLang: widget.currentLang, 
          tr: widget.tr, 
          searchKeyword: keyword,
          isLoggedIn: widget.isLoggedIn,
          isAdmin: widget.isAdmin,
          onLanguageChange: widget.onLanguageChange,
          onLoginClick: () => _showLoginDialog(),
          onLogoutClick: widget.onLogout,
        )
      )
    );
  }

  void _showLoginDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(
        onLogin: widget.onLogin,
        authRepository: widget.authRepository,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1200 ? 5 : (screenWidth > 800 ? 3 : 2);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CoupangHeader(
            currentLang: widget.currentLang,
            isLoggedIn: widget.isLoggedIn,
            isAdmin: widget.isAdmin,
            userName: widget.userName,
            tr: widget.tr,
            onLanguageChange: widget.onLanguageChange,
            onLoginClick: _showLoginDialog,
            onLogoutClick: widget.onLogout,
            onSearch: _goToSearchResult,
            onUpdateProducts: _refreshProducts,
            onCategorySelect: _filterByCategory, // [연결]
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: kMaxWidth),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 350,
                        margin: const EdgeInsets.only(top: 20),
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.image, size: 80, color: Colors.grey)),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          // 카테고리 선택 시 제목 변경
                          _currentCategory != null 
                            ? widget.tr(_currentCategory!) 
                            : widget.tr('best_seller'),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 20),

                      FutureBuilder<List<Product>>(
                        // [수정] 카테고리 여부에 따라 데이터 요청 분기
                        future: _currentCategory == null 
                          ? widget.productRepository.getProducts() 
                          : widget.productRepository.getProductsByCategory(_currentCategory!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()));
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text("데이터를 불러오는 중 오류가 발생했습니다."));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Container(
                              height: 200,
                              alignment: Alignment.center,
                              child: Text("등록된 상품이 없습니다.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                            );
                          }

                          final products = snapshot.data!;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 0.48, 
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 20,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                product: products[index],
                                specialPriceText: widget.tr('special_price'),
                                currentLang: widget.currentLang,
                                tr: widget.tr,
                                isLoggedIn: widget.isLoggedIn,
                                isAdmin: widget.isAdmin,
                                onLanguageChange: widget.onLanguageChange,
                                onLoginClick: _showLoginDialog,
                                onLogoutClick: widget.onLogout,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}