// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import '../constants/data.dart';
import '../repositories/mock_auth_repository.dart';
import 'signup_page.dart';
import 'find_password_page.dart';

class LoginPage extends StatefulWidget {
  final Function(bool, bool, String) onLogin;
  final MockAuthRepository authRepository;

  const LoginPage({super.key, required this.onLogin, required this.authRepository});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _tryLogin() async {
    String email = _emailController.text;
    String pw = _passwordController.text;

    int result = await widget.authRepository.login(email, pw);
    
    if (result == 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("아이디 또는 비밀번호가 잘못되었습니다.")));
    } else {
      String name = widget.authRepository.getName(email);
      bool isAdmin = (result == 2);
      
      widget.onLogin(isAdmin, false, name); 
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _tryGoogleLogin() {
    widget.onLogin(false, false, "Google User");
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.jpg', 
                width: 200, height: 100, fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Text("Foreigner Info Shop", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kPrimaryColor)),
              ),
              const SizedBox(height: 40),

              // 이메일 입력
              TextField(
                controller: _emailController,
                textInputAction: TextInputAction.next, // 다음 칸으로 이동
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                  hintText: '아이디(이메일)',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              const SizedBox(height: 15),

              // 비밀번호 입력
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                textInputAction: TextInputAction.done, // 완료 버튼
                onSubmitted: (_) => _tryLogin(), // [추가] 엔터 치면 로그인 실행
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                  hintText: '비밀번호',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              Row(
                children: [
                  Checkbox(value: true, onChanged: (v){}, activeColor: kPrimaryColor),
                  const Text("자동 로그인", style: TextStyle(color: Colors.grey)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FindPasswordPage()));
                    }, 
                    child: const Text("비밀번호 찾기 >", style: TextStyle(color: Colors.grey))
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _tryLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text("로그인", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 15),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _tryGoogleLogin,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png",
                        height: 24,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata),
                      ),
                      const SizedBox(width: 10),
                      const Text("Sign in with Google", style: TextStyle(color: Colors.black, fontSize: 16)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(authRepository: widget.authRepository)));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text("회원가입", style: TextStyle(color: Colors.black, fontSize: 16)),
                ),
              ),
              
              const SizedBox(height: 30),
              const Text("© Foreigner Info Center. All rights reserved.", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}