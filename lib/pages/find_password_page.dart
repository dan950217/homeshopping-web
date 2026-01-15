// lib/pages/find_password_page.dart
import 'package:flutter/material.dart';
import '../constants/data.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({super.key});

  @override
  State<FindPasswordPage> createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isCodeSent = false;

  void _sendCode() {
    if (_emailController.text.isEmpty) return;
    // 실제로는 여기서 서버로 인증메일 발송 요청
    setState(() => _isCodeSent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("인증번호가 발송되었습니다. (테스트용: 아무거나 입력)")),
    );
  }

  void _verifyCode() {
    // 실제로는 서버에 인증번호 확인 요청
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("인증 완료"),
        content: const Text("비밀번호 재설정 페이지로 이동합니다. (Mock)"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("확인"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("비밀번호 찾기"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("가입한 이메일 주소를 입력해주세요.", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "이메일",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _sendCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    fixedSize: const Size(100, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text("인증번호\n받기", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
            if (_isCodeSent) ...[
              const SizedBox(height: 20),
              const Text("이메일로 전송된 인증번호를 입력해주세요.", style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: "인증번호 6자리",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      fixedSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text("확인", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}