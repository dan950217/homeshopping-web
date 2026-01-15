// lib/pages/search_page.dart
import 'package:flutter/material.dart';
import '../constants/data.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/coupang_header.dart';
import '../repositories/product_repository.dart';

class SearchResultPage extends StatefulWidget {
  final ProductRepository productRepository; 
  final String currentLang;
  final Function(String) tr;
  final String searchKeyword;
  final bool isLoggedIn;
  final bool isAdmin;
  final Function(String) onLanguageChange;
  final VoidCallback onLoginClick;
  final VoidCallback onLogoutClick;

  const SearchResultPage({
    super.key,
    required this.productRepository,
    required this.currentLang, 
    required this.tr, 
    required this.searchKeyword,
    required this.isLoggedIn,
    required this.isAdmin,
    required this.onLanguageChange,
    required this.onLoginClick,
    required this.onLogoutClick,
  });

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late Future<List<Product>> _searchFuture;

  @override
  void initState() {
    super.initState();
    _searchFuture = widget.productRepository.searchProducts(widget.searchKeyword);
  }

  void _performSearch(String keyword) {
    if (keyword.trim().isEmpty) return;
    // [수정] 검색 페이지에서 또 검색하면 현재 창을 교체(Replacement)
    Navigator.pushReplacement(
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
          onLoginClick: widget.onLoginClick,
          onLogoutClick: widget.onLogoutClick,
        )
      )
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
            initialSearchValue: widget.searchKeyword, // [추가] 검색어 유지
            tr: widget.tr,
            onLanguageChange: widget.onLanguageChange,
            onLoginClick: widget.onLoginClick,
            onLogoutClick: widget.onLogoutClick,
            onSearch: _performSearch, // [수정] 연결
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: kMaxWidth),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "'${widget.searchKeyword}' ${widget.tr('search_result')}", 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ),
                      
                      FutureBuilder<List<Product>>(
                        future: _searchFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()));
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text("오류가 발생했습니다: ${snapshot.error}"));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(50.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.search_off, size: 60, color: Colors.grey),
                                    const SizedBox(height: 20),
                                    Text(widget.tr('no_search_result'), style: const TextStyle(fontSize: 18, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            );
                          }

                          final searchResults = snapshot.data!;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 0.48, 
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 20,
                            ),
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                product: searchResults[index],
                                specialPriceText: widget.tr('special_price'),
                                currentLang: widget.currentLang,
                                tr: widget.tr,
                                isLoggedIn: widget.isLoggedIn,
                                isAdmin: widget.isAdmin,
                                onLanguageChange: widget.onLanguageChange,
                                onLoginClick: widget.onLoginClick,
                                onLogoutClick: widget.onLogoutClick,
                              );
                            },
                          );
                        },
                      ),
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