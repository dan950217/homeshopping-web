// lib/repositories/mock_auth_repository.dart

class MockAuthRepository {
  // 가짜 DB (이메일: 비밀번호)
  final Map<String, String> _users = {
    'admin@gmail.com': '12345',
    'user@gmail.com': '12345',
  };

  // 사용자 이름 저장용
  final Map<String, String> _userNames = {
    'admin@gmail.com': '관리자',
    'user@gmail.com': '홍길동',
  };

  // 로그인 시도
  // 리턴값: 0(실패), 1(유저), 2(관리자)
  Future<int> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // 통신 딜레이

    if (_users.containsKey(email) && _users[email] == password) {
      if (email == 'admin@gmail.com') return 2; // 관리자
      return 1; // 일반 유저
    }
    return 0; // 실패
  }

  // 회원가입
  Future<bool> signUp(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_users.containsKey(email)) return false; // 이미 존재

    _users[email] = password;
    _userNames[email] = name;
    return true;
  }

  // 이름 가져오기
  String getName(String email) {
    return _userNames[email] ?? "고객";
  }
}