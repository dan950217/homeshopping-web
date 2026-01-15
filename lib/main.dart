// lib/main.dart
import 'package:flutter/material.dart';
import 'constants/data.dart';
import 'pages/home_page.dart';
import 'repositories/product_repository.dart';
import 'repositories/mock_product_repository.dart';
import 'repositories/mock_auth_repository.dart'; // [추가]

void main() {
  final ProductRepository repository = MockProductRepository();
  final MockAuthRepository authRepository = MockAuthRepository(); // [추가]
  runApp(MyApp(productRepository: repository, authRepository: authRepository));
}

class MyApp extends StatefulWidget {
  final ProductRepository productRepository;
  final MockAuthRepository authRepository;

  const MyApp({super.key, required this.productRepository, required this.authRepository});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _currentLang = 'ko';
  bool _isLoggedIn = false;
  bool _isAdmin = false;
  bool _isSeller = false;
  String _userName = ""; // [추가]

  void _changeLanguage(String langCode) => setState(() => _currentLang = langCode);
  
  // [수정] 로그인 시 이름도 받음
  void _login(bool asAdmin, bool asSeller, String name) => setState(() { 
    _isLoggedIn = true; 
    _isAdmin = asAdmin; 
    _isSeller = asSeller;
    _userName = name;
  });
  
  void _logout() => setState(() { 
    _isLoggedIn = false; 
    _isAdmin = false; 
    _isSeller = false; 
    _userName = "";
  });

  String tr(String key) => localizedValues[_currentLang]?[key] ?? localizedValues['en']?[key] ?? key;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foreigner Info Shop',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        useMaterial3: true,
        fontFamily: 'Noto Sans KR',
        checkboxTheme: kCheckboxTheme,
      ),
      home: ShoppingMainPage(
        productRepository: widget.productRepository,
        authRepository: widget.authRepository, // [추가]
        currentLang: _currentLang,
        isLoggedIn: _isLoggedIn,
        isAdmin: _isAdmin,
        isSeller: _isSeller,
        userName: _userName, // [추가]
        onLanguageChange: _changeLanguage,
        onLogin: _login,
        onLogout: _logout,
        tr: tr,
      ),
    );
  }
}