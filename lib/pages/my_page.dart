// lib/pages/my_page.dart
import 'package:flutter/material.dart';
import '../constants/data.dart';
import '../widgets/coupang_header.dart';
import '../repositories/mock_product_repository.dart';
import 'search_page.dart';

class MyPage extends StatelessWidget {
  final String userName;
  final String currentLang;
  final Function(String) tr;
  final bool isLoggedIn;
  final bool isAdmin;
  final Function(String) onLanguageChange;
  final VoidCallback onLogoutClick;

  const MyPage({
    super.key,
    required this.userName,
    required this.currentLang,
    required this.tr,
    required this.isLoggedIn,
    required this.isAdmin,
    required this.onLanguageChange,
    required this.onLogoutClick,
  });

  // [추가] 검색 로직
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
          isLoggedIn: isLoggedIn,
          isAdmin: isAdmin,
          onLanguageChange: onLanguageChange,
          onLoginClick: () {},
          onLogoutClick: onLogoutClick,
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          CoupangHeader(
            currentLang: currentLang,
            isLoggedIn: isLoggedIn,
            isAdmin: isAdmin,
            userName: userName,
            onLanguageChange: onLanguageChange,
            onLoginClick: () {}, 
            onLogoutClick: onLogoutClick,
            tr: tr,
            onSearch: (q) => _goToSearchResult(context, q), // [수정] 연결
          ),
          
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: kMaxWidth),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(Icons.person, size: 40, color: Colors.grey),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$userName님, 안녕하세요!", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5),
                                const Text("개인회원 | 마이페이지", style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20, bottom: 20),
                              child: Text("진행 중인 주문", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildOrderStatusItem("0", "결제완료"),
                                _buildIconArrow(),
                                _buildOrderStatusItem("1", "배송준비중"),
                                _buildIconArrow(),
                                _buildOrderStatusItem("0", "배송중"),
                                _buildIconArrow(),
                                _buildOrderStatusItem("0", "배송완료"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("자주 찾는 메뉴", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: [
                                _buildQuickMenu(Icons.refresh, "취소/반품/교환"),
                                _buildQuickMenu(Icons.receipt_long, "영수증 조회"),
                                _buildQuickMenu(Icons.favorite_border, "찜한 상품"),
                                _buildQuickMenu(Icons.location_on_outlined, "배송지 관리"),
                                _buildQuickMenu(Icons.lock_outline, "개인정보 수정"),
                              ],
                            )
                          ],
                        ),
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

  Widget _buildOrderStatusItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildIconArrow() {
    return const Icon(Icons.chevron_right, color: Colors.grey);
  }

  Widget _buildQuickMenu(IconData icon, String label) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.grey[700]),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}