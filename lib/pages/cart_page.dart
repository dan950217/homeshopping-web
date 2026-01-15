// lib/pages/cart_page.dart
import 'package:flutter/material.dart';
import '../constants/data.dart';
import '../models/product.dart';
import '../widgets/coupang_header.dart';
// import '../repositories/product_repository.dart'; // [제거됨] 사용하지 않음
import '../repositories/mock_product_repository.dart'; 
import 'search_page.dart'; 

class CartPage extends StatefulWidget {
  final String currentLang;
  final Function(String) tr;
  final bool isLoggedIn;
  final bool isAdmin;
  final Function(String) onLanguageChange;
  final VoidCallback onLoginClick;
  final VoidCallback onLogoutClick;

  const CartPage({
    super.key, 
    required this.currentLang, 
    required this.tr,
    required this.isLoggedIn,
    required this.isAdmin,
    required this.onLanguageChange,
    required this.onLoginClick,
    required this.onLogoutClick,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollTopBtn = false;

  final CheckboxThemeData _localCheckboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return kPrimaryColor;
      }
      return null;
    }),
    side: const BorderSide(color: Colors.grey, width: 1.5),
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300) {
        if (!_showScrollTopBtn) setState(() => _showScrollTopBtn = true);
      } else {
        if (_showScrollTopBtn) setState(() => _showScrollTopBtn = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  // 검색 페이지 이동
  void _goToSearchResult(String keyword) {
    if (keyword.trim().isEmpty) return;
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => SearchResultPage(
          productRepository: MockProductRepository(), 
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
    int totalProductPrice = globalCartItems
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + (item.product.price * item.quantity));
        
    int totalDiscount = 0;
    int shippingFee = (totalProductPrice > 0 && totalProductPrice < 50000) ? 3000 : 0;
    int finalTotalPrice = totalProductPrice - totalDiscount + shippingFee;

    bool isWideScreen = MediaQuery.of(context).size.width > 900;

    return Theme(
      data: Theme.of(context).copyWith(checkboxTheme: _localCheckboxTheme),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Stack(
          children: [
            Column(
              children: [
                CoupangHeader(
                  currentLang: widget.currentLang,
                  isLoggedIn: widget.isLoggedIn,
                  isAdmin: widget.isAdmin,
                  tr: widget.tr,
                  onLanguageChange: widget.onLanguageChange,
                  onLoginClick: widget.onLoginClick,
                  onLogoutClick: widget.onLogoutClick,
                  onSearch: _goToSearchResult,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: kMaxWidth),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(widget.tr('cart_title'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            ),
                            globalCartItems.isEmpty
                                ? Container(
                                    height: 300,
                                    alignment: Alignment.center,
                                    child: Text(widget.tr('cart_empty'), style: const TextStyle(fontSize: 18, color: Colors.grey)),
                                  )
                                : (isWideScreen 
                                    ? _buildWideLayout(totalProductPrice, totalDiscount, shippingFee, finalTotalPrice) 
                                    : _buildNarrowLayout(totalProductPrice, totalDiscount, shippingFee, finalTotalPrice)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_showScrollTopBtn)
              Positioned(
                bottom: 30,
                right: 30,
                child: FloatingActionButton(
                  onPressed: _scrollToTop,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey[700],
                  elevation: 3,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.arrow_upward),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(int totalProd, int discount, int shipping, int finalTotal) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 7, child: _buildCartList()),
        const SizedBox(width: 20),
        Expanded(flex: 3, child: _buildSummaryBox(totalProd, discount, shipping, finalTotal)),
      ],
    );
  }

  Widget _buildNarrowLayout(int totalProd, int discount, int shipping, int finalTotal) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCartList(),
          const SizedBox(height: 20),
          _buildSummaryBox(totalProd, discount, shipping, finalTotal),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 5),
          child: Text("일반구매(${globalCartItems.length})", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: globalCartItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            return _buildCartItemBox(globalCartItems[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildCartItemBox(CartItem cartItem, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: cartItem.isSelected, 
            onChanged: (bool? val) {
              setState(() {
                cartItem.isSelected = val ?? false;
              });
            },
            activeColor: kPrimaryColor,
          ),
          Image.network(
            cartItem.product.imageUrl, 
            width: 90, 
            height: 90, 
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 90, height: 90, color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.tr(cartItem.product.titleKey), style: const TextStyle(fontSize: 15), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Text("내일(글피) 도착 보장", style: TextStyle(color: Colors.green.shade700, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text("${formatPrice(cartItem.product.price)}원", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Container(
                       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                       decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), borderRadius: BorderRadius.circular(2)),
                       child: const Text("로켓배송", style: TextStyle(color: kPrimaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                 Container(
                  width: 100,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 16), 
                        padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                        onPressed: () {
                          if (cartItem.quantity > 1) {
                            setState(() => cartItem.quantity--);
                          }
                        }, 
                      ),
                      Text(cartItem.quantity.toString(), style: const TextStyle(fontSize: 15)),
                      IconButton(
                        icon: const Icon(Icons.add, size: 16), 
                        padding: EdgeInsets.zero, constraints: const BoxConstraints(),
                        onPressed: () {
                          setState(() => cartItem.quantity++);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: (){
              setState(() {
                globalCartItems.removeAt(index);
              });
            }, 
            icon: const Icon(Icons.close, color: Colors.grey, size: 20)
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(int totalProd, int discount, int shipping, int finalTotal) {
    int selectedCount = globalCartItems.where((i) => i.isSelected).length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kPrimaryColor, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Container(
             padding: const EdgeInsets.all(15),
             decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
             child: Text(widget.tr('order_summary'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
           ),
           Padding(
             padding: const EdgeInsets.all(20),
             child: Column(
               children: [
                 _buildSummaryRow(widget.tr('total_prod_price'), formatPrice(totalProd)),
                 const SizedBox(height: 10),
                 _buildSummaryRow(widget.tr('total_discount'), "-${formatPrice(discount)}", isDiscount: true),
                 const SizedBox(height: 10),
                 _buildSummaryRow(widget.tr('shipping_fee'), "+${formatPrice(shipping)}"),
                 const Divider(height: 30),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(widget.tr('final_payment'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                     Text("${formatPrice(finalTotal)}원", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kCoupangRed)),
                   ],
                 )
               ],
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(15),
             child: ElevatedButton(
                onPressed: selectedCount > 0 ? () {} : null, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor, 
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
                ),
                child: Text("${widget.tr('checkout')} ($selectedCount)", style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
           )
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, color: Colors.grey)),
        Text(value + (isDiscount ? "" : "원"), style: TextStyle(fontSize: 15, color: isDiscount ? kDiscountBlue : Colors.black)),
      ],
    );
  }
}