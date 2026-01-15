// lib/models/product.dart

class Product {
  final String id;
  final String titleKey;
  final String imageUrl;
  final List<String> detailImages;
  final int originalPrice;
  final int discountRate;
  final double rating;
  final int reviewCount;
  final List<Review> reviews;
  final List<QnA> qnas;
  
  // [신규 필드]
  final String category; 
  final String description; // 상세 설명 (HTML이나 텍스트)

  Product({
    required this.id,
    required this.titleKey,
    required this.imageUrl,
    this.detailImages = const [],
    required this.originalPrice,
    required this.discountRate,
    required this.rating,
    required this.reviewCount,
    this.reviews = const [],
    this.qnas = const [],
    this.category = "기타", // 기본값
    this.description = "", // 기본값
  });

  int get price => (originalPrice * (100 - discountRate) / 100).round();
}

class CartItem {
  final Product product;
  int quantity;
  bool isSelected;

  CartItem({required this.product, this.quantity = 1, this.isSelected = true});
}

class Review {
  final String userName;
  final String date;
  final int rating;
  final String content;
  final String? reviewImage;

  Review({
    required this.userName,
    required this.date,
    required this.rating,
    required this.content,
    this.reviewImage,
  });
}

class QnA {
  final String userName;
  final String date;
  final String question;
  final String? answer;
  final String? answerDate;
  final bool isSecret;

  QnA({
    required this.userName,
    required this.date,
    required this.question,
    this.answer,
    this.answerDate,
    this.isSecret = false,
  });
}