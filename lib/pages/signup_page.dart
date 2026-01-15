// lib/pages/signup_page.dart
import 'package:flutter/material.dart';
import '../constants/data.dart';
import '../constants/terms.dart';
import '../repositories/mock_auth_repository.dart';

class SignUpPage extends StatefulWidget {
  final MockAuthRepository? authRepository;

  const SignUpPage({super.key, this.authRepository});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwCheckController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  
  // 선택된 값 저장 변수
  String? _selectedCountry;
  String? _selectedVisa;
  String? _selectedRegion;

  bool _isPwVisible = false;
  bool _isPwCheckVisible = false;

  bool _isAllAgreed = false;
  bool _isServiceAgreed = false;
  bool _isPrivacyAgreed = false;
  bool _isEmailAgreed = false;

  void _toggleAll(bool? value) {
    setState(() {
      _isAllAgreed = value ?? false;
      _isServiceAgreed = _isAllAgreed;
      _isPrivacyAgreed = _isAllAgreed;
      _isEmailAgreed = _isAllAgreed;
    });
  }

  void _updateAllState() {
    setState(() {
      _isAllAgreed = _isServiceAgreed && _isPrivacyAgreed && _isEmailAgreed;
    });
  }

  void _showTermDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 500,
          height: 600,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                  child: const Text("확인", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processSignUp() async {
    // [수정] 경고 해결을 위해 변수 사용 (실제로는 이 값들을 서버로 보냄)
    print("추가 정보 - 국가: $_selectedCountry, 비자: $_selectedVisa, 지역: $_selectedRegion, 연락처: ${_contactController.text}");

    if (widget.authRepository != null) {
      bool success = await widget.authRepository!.signUp(
        _emailController.text, 
        _pwController.text, 
        _nameController.text
      );

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("가입이 완료되었습니다. 로그인해주세요.")));
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("이미 존재하는 이메일입니다.")));
      }
    } else {
      // Repository가 없는 경우 (UI 테스트용)
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("회원가입", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("이메일"),
                TextField(
                  controller: _emailController,
                  decoration: _inputDecoration("이메일 입력"),
                ),
                const SizedBox(height: 20),

                _buildLabel("비밀번호"),
                TextField(
                  controller: _pwController,
                  obscureText: !_isPwVisible,
                  decoration: _inputDecoration("영문, 숫자, 특수문자 포함 10자 이상").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_isPwVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                      onPressed: () => setState(() => _isPwVisible = !_isPwVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _pwCheckController,
                  obscureText: !_isPwCheckVisible,
                  decoration: _inputDecoration("비밀번호 재입력").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_isPwCheckVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                      onPressed: () => setState(() => _isPwCheckVisible = !_isPwCheckVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                _buildLabel("이름"),
                TextField(
                  controller: _nameController,
                  decoration: _inputDecoration("이름 입력"),
                ),
                const SizedBox(height: 20),

                _buildLabel("국가/지역"),
                _buildSearchableDropdown(
                  hint: "국가 검색",
                  items: countryList,
                  onSelected: (val) => _selectedCountry = val,
                ),
                const SizedBox(height: 20),

                _buildLabel("비자 코드"),
                _buildSearchableDropdown(
                  hint: "비자 검색 (없음)",
                  items: visaList,
                  onSelected: (val) => _selectedVisa = val,
                ),
                const SizedBox(height: 20),

                _buildLabel("연락처"),
                TextField(
                  controller: _contactController,
                  decoration: _inputDecoration("'-' 제외"),
                ),
                const SizedBox(height: 20),

                _buildLabel("거주 지역"),
                _buildSearchableDropdown(
                  hint: "지역 검색",
                  items: regionList,
                  onSelected: (val) => _selectedRegion = val,
                ),
                const SizedBox(height: 40),

                const Text("약관동의", style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(),
                _buildTermRow("[필수] 서비스 이용약관 동의", _isServiceAgreed, (v) {
                  setState(() { _isServiceAgreed = v!; _updateAllState(); });
                }, serviceTerms),
                _buildTermRow("[필수] 개인정보처리방침 동의", _isPrivacyAgreed, (v) {
                  setState(() { _isPrivacyAgreed = v!; _updateAllState(); });
                }, privacyTerms),
                _buildTermRow("[선택] 이메일 무단 수집 거부", _isEmailAgreed, (v) {
                  setState(() { _isEmailAgreed = v!; _updateAllState(); });
                }, emailTerms),
                
                const Divider(),
                Row(
                  children: [
                    Checkbox(value: _isAllAgreed, onChanged: _toggleAll, activeColor: kPrimaryColor),
                    const Text("모두 동의하기", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (_isServiceAgreed && _isPrivacyAgreed) ? _processSignUp : null, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text("가입 요청", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchableDropdown({
    required String hint, 
    required List<String> items, 
    required Function(String?) onSelected
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<String>(
          width: constraints.maxWidth,
          menuHeight: 400,
          enableFilter: true,
          requestFocusOnTap: true,
          leadingIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: hint,
          inputDecorationTheme: const InputDecorationTheme(
            filled: false,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(),
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          dropdownMenuEntries: items.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(
              value: value, 
              label: value,
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 14)),
              ),
            );
          }).toList(),
          onSelected: onSelected,
        );
      }
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
    );
  }

  Widget _buildTermRow(String title, bool value, Function(bool?) onChanged, String termContent) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged, activeColor: kPrimaryColor),
        Text(title, style: TextStyle(fontSize: 14, fontWeight: title.contains("필수") ? FontWeight.bold : FontWeight.normal)),
        const Spacer(),
        TextButton(
          onPressed: () => _showTermDialog(title, termContent), 
          child: const Text("자세히 >", style: TextStyle(fontSize: 12, color: Colors.grey))
        ),
      ],
    );
  }
}