// lib/widgets/coupang_header.dart
import 'package:flutter/material.dart';
import '../constants/data.dart';
import '../pages/cart_page.dart';
import '../pages/admin_page.dart';
import '../pages/my_page.dart';
import '../pages/product_upload_page.dart';

class CoupangHeader extends StatefulWidget {
  final String currentLang;
  final bool isLoggedIn;
  final bool isAdmin;
  final String userName;
  final String? initialSearchValue;
  final Function(String) onLanguageChange;
  final VoidCallback onLoginClick;
  final VoidCallback onLogoutClick;
  final Function(String) tr;
  final Function(String) onSearch;
  final VoidCallback? onUpdateProducts;
  final Function(String)? onCategorySelect; // [추가] 카테고리 선택 콜백

  const CoupangHeader({
    super.key,
    required this.currentLang,
    required this.isLoggedIn,
    required this.isAdmin,
    this.userName = "",
    this.initialSearchValue,
    required this.onLanguageChange,
    required this.onLoginClick,
    required this.onLogoutClick,
    required this.tr,
    required this.onSearch,
    this.onUpdateProducts,
    this.onCategorySelect, // [추가]
  });

  @override
  State<CoupangHeader> createState() => _CoupangHeaderState();
}

class _CoupangHeaderState extends State<CoupangHeader> {
  final LayerLink _categoryLink = LayerLink();
  OverlayEntry? _categoryOverlay;
  bool _isCategoryOpen = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearchValue ?? "");
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCategoryOverlay() {
    if (_isCategoryOpen) return;
    _categoryOverlay = _createCategoryOverlay();
    Overlay.of(context).insert(_categoryOverlay!);
    setState(() => _isCategoryOpen = true);
  }

  void _hideCategoryOverlay() {
    _categoryOverlay?.remove();
    _categoryOverlay = null;
    setState(() => _isCategoryOpen = false);
  }

  OverlayEntry _createCategoryOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: 160,
        child: CompositedTransformFollower(
          link: _categoryLink,
          offset: const Offset(0, 50),
          showWhenUnlinked: false,
          child: MouseRegion(
            onEnter: (_) => _showCategoryOverlay(),
            onExit: (_) => _hideCategoryOverlay(),
            child: Material(
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categoryKeys.map((key) => _buildMenuItem(key, widget.tr(key))).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String key, String title) {
    return InkWell(
      onTap: () {
        _hideCategoryOverlay();
        if (widget.onCategorySelect != null) {
          widget.onCategorySelect!(key);
        } else {
          // 홈 화면이 아닌 곳에서 카테고리 클릭 시 검색과 비슷하게 처리하거나 홈으로 이동해야 함
          // 여기선 단순 검색으로 처리
          widget.onSearch(title);
        }
      },
      hoverColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(title, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("언어 변경 (Language)"),
            IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          ],
        ),
        content: SizedBox(
          width: 600,
          height: 500,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 3.5, crossAxisSpacing: 10, mainAxisSpacing: 10
            ),
            itemCount: supportedLanguages.length,
            itemBuilder: (context, index) {
              final lang = supportedLanguages[index];
              return InkWell(
                onTap: () {
                  widget.onLanguageChange(lang['code']!);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Text(lang['name']!, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onSellClick() async {
    if (widget.isLoggedIn) {
      if (widget.isAdmin) {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductUploadPage()));
        if (widget.onUpdateProducts != null) {
          widget.onUpdateProducts!();
        }
      } else {
        // [수정] 일반 유저용 안내 팝업
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            contentPadding: const EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.build_circle_outlined, size: 60, color: Colors.grey),
                const SizedBox(height: 20),
                const Text("판매자 서비스 준비 중입니다.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text("빠른 시일 내에 오픈할 예정입니다.\n조금만 기다려주세요!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("확인"))
            ],
          ),
        );
      }
    } else {
      widget.onLoginClick(); 
    }
  }

  void _onMyPageClick() {
    if (widget.isLoggedIn) {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => MyPage(
          userName: widget.userName,
          currentLang: widget.currentLang,
          tr: widget.tr,
          isLoggedIn: widget.isLoggedIn,
          isAdmin: widget.isAdmin,
          onLanguageChange: widget.onLanguageChange,
          onLogoutClick: _performLogout, 
        ))
      );
    } else {
      widget.onLoginClick();
    }
  }

  void _performLogout() {
    widget.onLogoutClick();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _buildTopBar() {
    if (!widget.isLoggedIn) return const SizedBox.shrink();

    return Container(
      color: Colors.grey[200],
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: kMaxWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("${widget.userName} 님", style: const TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(width: 15),
              InkWell(
                onTap: _performLogout,
                child: const Text("로그아웃", style: TextStyle(fontSize: 12, color: Colors.black54)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        Container(
          decoration: BoxDecoration(
            color: Colors.white, 
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: kMaxWidth),
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: [
                  CompositedTransformTarget(
                    link: _categoryLink,
                    child: MouseRegion(
                      onEnter: (_) => _showCategoryOverlay(),
                      child: InkWell(
                        onTap: _showCategoryOverlay,
                        child: Container(
                          width: 110,
                          height: 100,
                          color: kPrimaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.menu, color: Colors.white, size: 30),
                              const SizedBox(height: 4),
                              Text(widget.tr('category'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  InkWell(
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }, 
                    child: Image.asset(
                      'assets/images/logo.jpg', 
                      width: 140,
                      height: 70, 
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                         return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Foreigner", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
                            Text("Center", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          const Text("전체", style: TextStyle(color: Colors.grey, fontSize: 13)),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                          const VerticalDivider(color: Colors.grey, indent: 10, endIndent: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onSubmitted: (value) => widget.onSearch(value),
                              decoration: InputDecoration(
                                hintText: widget.tr('search_hint'),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(bottom: 5),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => widget.onSearch(_searchController.text),
                            icon: const Icon(Icons.search, color: kPrimaryColor),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  Row(
                    children: [
                      if (widget.isAdmin)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDashboardPage(currentLang: widget.currentLang, tr: widget.tr)));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.dashboard, size: 28, color: kCoupangRed),
                                const SizedBox(height: 4),
                                Text("대시보드", style: const TextStyle(fontSize: 11, color: kCoupangRed, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),

                      InkWell(
                        onTap: _onMyPageClick,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_outline, size: 28, color: Colors.grey[800]),
                              const SizedBox(height: 4),
                              Text(
                                widget.isLoggedIn ? widget.tr('mypage') : "로그인/회원가입", 
                                style: const TextStyle(fontSize: 11)
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (!widget.isAdmin)
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(currentLang: widget.currentLang, tr: widget.tr, isLoggedIn: widget.isLoggedIn, isAdmin: widget.isAdmin, onLanguageChange: widget.onLanguageChange, onLoginClick: widget.onLoginClick, onLogoutClick: widget.onLogoutClick)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Badge(
                                  label: Text(globalCartItems.length.toString()),
                                  child: Icon(Icons.shopping_cart_outlined, size: 28, color: Colors.grey[800]),
                                ),
                                const SizedBox(height: 4),
                                Text(widget.tr('cart'), style: const TextStyle(fontSize: 11)),
                              ],
                            ),
                          ),
                        ),

                      InkWell(
                        onTap: _onSellClick,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.storefront_outlined, size: 28, color: Colors.grey[800]),
                              const SizedBox(height: 4),
                              Text(widget.tr('sell'), style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                      ),

                       InkWell(
                        onTap: () => _showLanguageDialog(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.language, size: 26, color: Colors.grey[800]),
                              const SizedBox(height: 4),
                              const Text("Language", style: TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}