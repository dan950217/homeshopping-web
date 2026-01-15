// lib/pages/product_detail_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../constants/data.dart';
import '../models/product.dart';
import '../widgets/coupang_header.dart';
import '../repositories/mock_product_repository.dart';
import 'search_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final String currentLang;
  final Function(String) tr;
  final bool isLoggedIn;
  final bool isAdmin;
  final Function(String) onLanguageChange;
  final VoidCallback onLoginClick;
  final VoidCallback onLogoutClick;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.currentLang,
    required this.tr,
    required this.isLoggedIn,
    required this.isAdmin,
    required this.onLanguageChange,
    required this.onLoginClick,
    required this.onLogoutClick,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _detailKey = GlobalKey();
  final GlobalKey _reviewKey = GlobalKey();
  final GlobalKey _qnaKey = GlobalKey();

  int _selectedTabIndex = 0;
  bool _showScrollTopBtn = false;
  late String _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.product.imageUrl;
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

  void _scrollToSection(GlobalKey key, int index) {
    setState(() => _selectedTabIndex = index);
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

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
    return Scaffold(
      backgroundColor: Colors.white,
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTopSection(),
                          const SizedBox(height: 40),
                          _buildTabBar(),
                          const SizedBox(height: 20),
                          Container(key: _detailKey, child: _buildDetailSection()),
                          const Divider(height: 60, thickness: 10, color: Color(0xFFF5F5F5)),
                          Container(key: _reviewKey, child: _buildReviewSection()),
                          const Divider(height: 60, thickness: 10, color: Color(0xFFF5F5F5)),
                          Container(key: _qnaKey, child: _buildQnASection()),
                          const SizedBox(height: 100),
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
    );
  }

  Widget _buildTopSection() {
    List<String> allImages = [widget.product.imageUrl, ...widget.product.detailImages];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(_currentImageUrl, fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentImageUrl = allImages[index];
                        });
                      },
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _currentImageUrl == allImages[index] ? kPrimaryColor : Colors.grey.shade300,
                            width: _currentImageUrl == allImages[index] ? 2 : 1,
                          ),
                        ),
                        child: Image.network(allImages[index], fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.tr(widget.product.titleKey), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  ...List.generate(5, (index) => Icon(
                    index < widget.product.rating.round() ? Icons.star : Icons.star_border, 
                    color: kStarYellow, size: 18
                  )),
                  const SizedBox(width: 5),
                  Text("${widget.product.reviewCount}개 상품평", style: const TextStyle(color: Colors.blue)),
                ],
              ),
              const Divider(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("${widget.product.discountRate}%", style: const TextStyle(fontSize: 20, color: Colors.grey)),
                  const SizedBox(width: 10),
                  Text("${formatPrice(widget.product.price)}원", style: const TextStyle(fontSize: 30, color: kCoupangRed, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 5),
              Text("원가: ${formatPrice(widget.product.originalPrice)}원", style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), side: const BorderSide(color: kPrimaryColor)),
                      child: const Text("장바구니 담기", style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor, padding: const EdgeInsets.symmetric(vertical: 15)),
                      child: const Text("바로 구매하기", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 2)),
      ),
      child: Row(
        children: [
          _buildTabItem(widget.tr('detail_tab_info'), 0, _detailKey),
          _buildTabItem("${widget.tr('detail_tab_review')} (${widget.product.reviewCount})", 1, _reviewKey),
          _buildTabItem("${widget.tr('detail_tab_qna')} (${widget.product.qnas.length})", 2, _qnaKey),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index, GlobalKey key) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _scrollToSection(key, index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: isSelected ? const Border(bottom: BorderSide(color: kPrimaryColor, width: 3)) : null,
            color: isSelected ? Colors.white : const Color(0xFFFAFAFA),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? kPrimaryColor : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection() {
    List<Widget> contentWidgets = [];
    String text = widget.product.description;
    
    List<String> parts = text.split(RegExp(r'(\[image:.*?\])'));
    
    for (String part in parts) {
      if (part.startsWith("[image:") && part.endsWith("]")) {
        String path = part.substring(7, part.length - 1);
        contentWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: kIsWeb 
              ? Image.network(path, fit: BoxFit.contain) 
              : Image.file(File(path), fit: BoxFit.contain),
          )
        );
      } else if (part.trim().isNotEmpty) {
        contentWidgets.add(_parseRichText(part));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(widget.tr('detail_tab_info'), style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 20),
        
        if (widget.product.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: contentWidgets,
            ),
          ),

        if (widget.product.detailImages.isEmpty)
          Container(height: 100, color: Colors.grey[200], child: const Center(child: Text("상세 페이지 이미지 영역")))
        else
          Column(
            children: widget.product.detailImages.map((url) => Image.network(url, width: double.infinity, fit: BoxFit.cover)).toList(),
          ),
      ],
    );
  }

  Widget _parseRichText(String text) {
    // <b> <i> 등의 태그를 지우고 순수 텍스트만 보여줍니다. (간단한 처리)
    // 실제 RichText 구현은 복잡하므로 텍스트만 깔끔하게 출력
    String cleanText = text.replaceAll(RegExp(r'<[^>]*>'), '');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(cleanText, style: const TextStyle(fontSize: 16, height: 1.6)),
    );
  }

  // [복구됨] 리뷰 섹션 전체 코드
  Widget _buildReviewSection() {
    Map<int, int> starCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var r in widget.product.reviews) {
      if (starCounts.containsKey(r.rating)) {
        starCounts[r.rating] = starCounts[r.rating]! + 1;
      }
    }
    int totalReviewCount = widget.product.reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(widget.tr('detail_tab_review'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        
        if (widget.product.reviews.isEmpty)
          const Padding(padding: EdgeInsets.all(20), child: Text("작성된 리뷰가 없습니다."))
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(5, (index) => Icon(
                            index < widget.product.rating.round() ? Icons.star : (index < widget.product.rating ? Icons.star_half : Icons.star_border),
                            color: kStarYellow, size: 28
                          )),
                          const SizedBox(width: 10),
                          Text(widget.product.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text("${widget.product.reviewCount}명 이상 만족했어요", style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 20),
                      
                      ...List.generate(5, (index) {
                        int star = 5 - index;
                        int count = starCounts[star] ?? 0;
                        double percent = totalReviewCount == 0 ? 0 : count / totalReviewCount;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              SizedBox(width: 40, child: Text(star == 5 ? "최고" : star == 4 ? "좋음" : star == 3 ? "보통" : star == 2 ? "별로" : "나쁨", style: const TextStyle(fontSize: 12, color: Colors.grey))),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: percent,
                                    backgroundColor: Colors.grey[300],
                                    color: kStarYellow,
                                    minHeight: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(width: 30, child: Text("${(percent * 100).round()}%", style: const TextStyle(fontSize: 12, color: Colors.grey))),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 30),
              
              Expanded(
                flex: 6,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.product.reviews.length,
                  separatorBuilder: (_, __) => const Divider(height: 30),
                  itemBuilder: (context, index) {
                    final review = widget.product.reviews[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(backgroundColor: Colors.grey, radius: 16, child: Icon(Icons.person, color: Colors.white, size: 20)),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(review.date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < review.rating ? kStarYellow : Colors.grey[300])),
                        ),
                        const SizedBox(height: 8),
                        Text(review.content, style: const TextStyle(height: 1.4)),
                        if (review.reviewImage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(review.reviewImage!, width: 80, height: 80, fit: BoxFit.cover),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  // [복구됨] QnA 섹션 전체 코드
  Widget _buildQnASection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(widget.tr('detail_tab_qna'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          color: Colors.grey[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBulletText(widget.tr('qna_notice_1')),
              _buildBulletText(widget.tr('qna_notice_2')),
              _buildBulletText(widget.tr('qna_notice_3')),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        ElevatedButton.icon(
          onPressed: widget.isLoggedIn ? () {} : null, 
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.grey),
            elevation: 0,
          ),
          icon: const Icon(Icons.edit),
          label: Text(widget.isLoggedIn ? widget.tr('write_inquiry') : widget.tr('login_needed_qna')),
        ),

        const SizedBox(height: 20),
        const Divider(),

        if (widget.product.qnas.isEmpty)
          const Padding(padding: EdgeInsets.all(20), child: Center(child: Text("등록된 문의가 없습니다.")))
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.product.qnas.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final qna = widget.product.qnas[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(2)),
                          child: const Text("질문", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ),
                        const SizedBox(width: 10),
                        Text(qna.userName, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(width: 10),
                        Text(qna.date, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(qna.question, style: const TextStyle(fontSize: 15)),
                    
                    if (qna.answer != null)
                      Container(
                        margin: const EdgeInsets.only(top: 15, left: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.subdirectory_arrow_right, size: 16, color: kPrimaryColor),
                                const SizedBox(width: 5),
                                const Text("판매자 답변", style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
                                const Spacer(),
                                Text(qna.answerDate ?? "", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(qna.answer!, style: const TextStyle(color: Colors.black87)),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

        const SizedBox(height: 30),

        if (widget.product.qnas.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.keyboard_arrow_left, color: Colors.grey)),
              Container(
                width: 30, height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(color: kPrimaryColor), color: Colors.white),
                child: const Text("1", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 5),
              Container(
                width: 30, height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                child: const Text("2", style: TextStyle(color: Colors.black)),
              ),
              IconButton(onPressed: (){}, icon: const Icon(Icons.keyboard_arrow_right, color: Colors.grey)),
            ],
          ),
      ],
    );
  }

  Widget _buildBulletText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: Colors.grey)),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4))),
        ],
      ),
    );
  }
}