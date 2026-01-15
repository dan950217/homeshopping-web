// lib/pages/admin_page.dart
import 'package:flutter/material.dart';
// import '../constants/data.dart'; // [제거됨] 사용하지 않음
import '../widgets/coupang_header.dart';
import '../repositories/mock_product_repository.dart';
import 'search_page.dart';

class AdminDashboardPage extends StatelessWidget {
  final String currentLang;
  final Function(String) tr;

  const AdminDashboardPage({super.key, required this.currentLang, required this.tr});

  // 검색 로직
  void _goToSearchResult(BuildContext context, String keyword) {
    if (keyword.trim().isEmpty) return;
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => SearchResultPage(
          productRepository: MockProductRepository(), 
          currentLang: currentLang, 
          tr: tr, 
          searchKeyword: keyword,
          isLoggedIn: true, // 관리자이므로 로그인 상태
          isAdmin: true,
          onLanguageChange: (lang) {}, // 대시보드에선 기능 생략
          onLoginClick: () {},
          onLogoutClick: () => Navigator.pop(context), // 로그아웃 시 홈으로
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 관리자 페이지에도 헤더 추가 (검색 가능하게)
          CoupangHeader(
            currentLang: currentLang,
            isLoggedIn: true,
            isAdmin: true,
            userName: "관리자",
            onLanguageChange: (l){},
            onLoginClick: (){},
            onLogoutClick: () => Navigator.pop(context),
            tr: tr,
            onSearch: (q) => _goToSearchResult(context, q),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.admin_panel_settings, size: 80, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text("관리자 대시보드", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("상품 등록, 주문 관리, 회원 관리 기능을 이곳에 구현합니다."),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: const Text("홈으로 돌아가기")
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}