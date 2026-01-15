// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../constants/data.dart';
import '../pages/product_detail_page.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final String specialPriceText;
  final String currentLang;
  final Function(String) tr;
  final bool isLoggedIn;
  final bool isAdmin;
  final Function(String) onLanguageChange;
  final VoidCallback onLoginClick;
  final VoidCallback onLogoutClick;

  const ProductCard({
    super.key,
    required this.product,
    required this.specialPriceText,
    required this.currentLang,
    required this.tr,
    required this.isLoggedIn,
    required this.isAdmin,
    required this.onLanguageChange,
    required this.onLoginClick,
    required this.onLogoutClick,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                product: widget.product,
                currentLang: widget.currentLang,
                tr: widget.tr,
                isLoggedIn: widget.isLoggedIn,
                isAdmin: widget.isAdmin,
                onLanguageChange: widget.onLanguageChange,
                onLoginClick: widget.onLoginClick,
                onLogoutClick: widget.onLogoutClick,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: _isHovering ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)] : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade200),
                    image: DecorationImage(
                      image: NetworkImage(widget.product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // [수정] 할인율이 0보다 클 때만 특가 배지 표시
              if (widget.product.discountRate > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: kStarYellow),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.specialPriceText,
                    style: const TextStyle(color: kStarYellow, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                )
              else 
                const SizedBox(height: 8), // 배지 없을 때 여백

              Text(
                widget.tr(widget.product.titleKey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.product.discountRate > 0) ...[
                    Text(
                      "${widget.product.discountRate}%",
                      style: const TextStyle(color: kDiscountBlue, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    "${formatPrice(widget.product.price)}원",
                    style: const TextStyle(color: kCoupangRed, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (widget.product.discountRate > 0)
                Text(
                  "${formatPrice(widget.product.originalPrice)}원",
                  style: const TextStyle(color: Colors.grey, fontSize: 12, decoration: TextDecoration.lineThrough),
                ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.star, color: kStarYellow, size: 14),
                  const Icon(Icons.star, color: kStarYellow, size: 14),
                  const Icon(Icons.star, color: kStarYellow, size: 14),
                  const Icon(Icons.star, color: kStarYellow, size: 14),
                  const Icon(Icons.star_half, color: kStarYellow, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "(${widget.product.reviewCount})",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}