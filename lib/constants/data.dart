// lib/constants/data.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';

// ---------------------------------------------------------
// 색상 및 상수 정의
// ---------------------------------------------------------
const Color kPrimaryColor = Color(0xFF800080);
const Color kBackgroundColor = Colors.white;
const Color kCoupangRed = Color(0xFFAE0000);
const Color kDiscountBlue = Color(0xFF4CA3F3);
const Color kStarYellow = Color(0xFFFFA422);
const double kMaxWidth = 1100.0;

// ---------------------------------------------------------
// 체크박스 테마
// ---------------------------------------------------------
final CheckboxThemeData kCheckboxTheme = CheckboxThemeData(
  fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.selected)) {
      return kPrimaryColor;
    }
    return null;
  }),
  side: const BorderSide(color: Colors.grey, width: 1.5),
);

// ---------------------------------------------------------
// 가격 포맷 함수
// ---------------------------------------------------------
String formatPrice(int price) {
  return NumberFormat('###,###,###,###').format(price);
}

// ---------------------------------------------------------
// 카테고리 키 리스트
// ---------------------------------------------------------
final List<String> categoryKeys = [
  "health", "beauty", "food", "daily", "electronics", "fashion", "safety",
];

// ---------------------------------------------------------
// 회원가입용 데이터 (국가, 비자, 지역)
// ---------------------------------------------------------
final List<String> countryList = [
  "가나", "가봉", "가이아나", "감비아", "건지 섬", "과들루프", "과테말라", "괌", "그레나다", "그리스", "그린란드", "기니", "기니비사우", "나미비아", "나우루", "나이지리아", "남수단", "남아프리카 공화국", "네덜란드", "네팔", "노르웨이", "노퍽 섬", "뉴칼레도니아", "뉴질랜드", "니우에", "니제르", "니카라과", "대한민국", "덴마크", "도미니카 공화국", "도미니카 연방", "독일", "동티모르", "라오스", "라이베리아", "라트비아", "러시아", "레바논", "레소토", "레위니옹", "루마니아", "룩셈부르크", "르완다", "리비아", "리투아니아", "리히텐슈타인", "마다가스카르", "마르티니크", "마셜 제도", "마요트", "마카오", "말라위", "말레이시아", "말리", "맨 섬", "멕시코", "모나코", "모로코", "모리셔스", "모리타니", "모잠비크", "몬테네그로", "몬트세랫", "몰도바", "몰디브", "몰타", "몽골", "미국", "미국령 버진아일랜드", "미얀마", "미크로네시아 연방", "바누아투", "바레인", "바바도스", "바티칸 시국", "바하마", "방글라데시", "버뮤다", "베냉", "베네수엘라", "베트남", "벨기에", "벨라루스", "벨리즈", "보스니아 헤르체고비나", "보츠와나", "볼리비아", "부룬디", "부르키나파소", "부탄", "북마리아나 제도", "북마케도니아", "불가리아", "브라질", "브루나이", "사모아", "사우디아라비아", "사이프러스(키프로스)", "산마리노", "상투메 프린시페", "생피에르 미클롱", "서사하라", "세네갈", "세르비아", "세이셸", "세인트루시아", "세인트빈센트 그레나딘", "세인트키츠 네비스", "세인트헬레나", "소말리아", "솔로몬 제도", "수단", "수리남", "스리랑카", "스발바르 얀마옌", "스웨덴", "스위스", "스페인", "슬로바키아", "슬로베니아", "시리아", "시에라리온", "싱가포르", "아랍에미리트", "아루바", "아르헨티나", "아메리칸 사모아", "아이슬란드", "아이티", "아일랜드", "아제르바이잔", "아프가니스탄", "안도라", "알바니아", "알제리", "앙골라", "앤티가 바부다", "앵귈라", "에리트레아", "에스와티니", "에스토니아", "에콰도르", "에티오피아", "엘살바도르", "영국", "영국령 버진아일랜드", "영국령 인도양 지역", "예멘", "오만", "오스트리아", "온두라스", "왈리스 푸투나", "요르단", "우간다", "우루과이", "우즈베키스탄", "우크라이나", "이라크", "이란", "이스라엘", "이집트", "이탈리아", "인도", "인도네시아", "일본", "자메이카", "잠비아", "저지 섬", "적도 기니", "조선민주주의인민공화국", "조지아", "중국", "중앙아프리카 공화국", "지부티", "지브롤터", "짐바브웨", "차드", "체코", "칠레", "카메룬", "카보베르데", "카자흐스탄", "카타르", "캄보디아", "캐나다", "케냐", "코모로", "코스타리카", "코코스 제도", "코트디부아르", "콜롬비아", "콩고 공화국", "콩고 민주 공화국", "쿠바", "쿠웨이트", "쿡 제도", "크로아티아", "크리스마스 섬", "키르기스스탄", "키리바시", "타이완(대만)", "타지키스탄", "탄자니아", "태국", "튀르키예(터키)", "토고", "토켈라우", "통가", "투르크메니스탄", "투발루", "튀니지", "트리니다드 토바고", "파나마", "파라과이", "파키스탄", "파푸아뉴기니", "팔라우", "팔레스타인", "페로 제도", "페루", "포르투갈", "포클랜드 제도", "폴란드", "푸에르토리코", "프랑스", "프랑스령 기아나", "프랑스령 폴리네시아", "피지", "핀란드", "필리핀", "핏케언 제도", "헝가리", "호주", "홍콩"
];

final List<String> visaList = [
  "없음",
  "A-1 (외교)", "A-2 (공무)", "A-3 (협정)", "B-1 (사증면제)", "B-2 (관광통과)", "C-1 (일시취재)", "C-3 (단기방문)", "C-4 (단기취업)", "D-1 (문화예술)", "D-2 (유학)", "D-3 (기술연수)", "D-4 (일반연수)", "D-5 (취재)", "D-6 (종교)", "D-7 (주재)", "D-8 (기업투자)", "D-9 (무역경영)", "D-10 (구직)", "E-1 (교수)", "E-2 (회화지도)", "E-3 (연구)", "E-4 (기술지도)", "E-5 (전문직업)", "E-6 (예술흥행)", "E-7 (특정활동)", "E-8 (계절근로)", "E-9 (비전문취업)", "E-10 (선원취업)", "F-1 (방문동거)", "F-2 (거주)", "F-3 (동반)", "F-4 (재외동포)", "F-5 (영주)", "F-6 (결혼이민)", "G-1 (기타)", "H-1 (관광취업)", "H-2 (방문취업)"
];

final List<String> regionList = [
  "서울특별시 강남구", "서울특별시 강동구", "서울특별시 강북구", "서울특별시 강서구", "서울특별시 관악구", "서울특별시 광진구", "서울특별시 구로구", "서울특별시 금천구", "서울특별시 노원구", "서울특별시 도봉구", "서울특별시 동대문구", "서울특별시 동작구", "서울특별시 마포구", "서울특별시 서대문구", "서울특별시 서초구", "서울특별시 성동구", "서울특별시 성북구", "서울특별시 송파구", "서울특별시 양천구", "서울특별시 영등포구", "서울특별시 용산구", "서울특별시 은평구", "서울특별시 종로구", "서울특별시 중구", "서울특별시 중랑구", 
  "부산광역시 강서구", "부산광역시 금정구", "부산광역시 기장군", "부산광역시 남구", "부산광역시 동구", "부산광역시 동래구", "부산광역시 부산진구", "부산광역시 북구", "부산광역시 사상구", "부산광역시 사하구", "부산광역시 서구", "부산광역시 수영구", "부산광역시 연제구", "부산광역시 영도구", "부산광역시 중구", "부산광역시 해운대구", 
  "대구광역시 군위군", "대구광역시 남구", "대구광역시 달서구", "대구광역시 달성군", "대구광역시 동구", "대구광역시 북구", "대구광역시 서구", "대구광역시 수성구", "대구광역시 중구", 
  "인천광역시 강화군", "인천광역시 계양구", "인천광역시 남동구", "인천광역시 동구", "인천광역시 미추홀구", "인천광역시 부평구", "인천광역시 서구", "인천광역시 연수구", "인천광역시 옹진군", "인천광역시 중구", 
  "광주광역시 광산구", "광주광역시 남구", "광주광역시 동구", "광주광역시 북구", "광주광역시 서구", 
  "대전광역시 대덕구", "대전광역시 동구", "대전광역시 서구", "대전광역시 유성구", "대전광역시 중구", 
  "울산광역시 남구", "울산광역시 동구", "울산광역시 북구", "울산광역시 울주군", "울산광역시 중구", 
  "세종특별자치시", 
  "경기도 가평군", "경기도 고양시 덕양구", "경기도 고양시 일산동구", "경기도 고양시 일산서구", "경기도 과천시", "경기도 광명시", "경기도 광주시", "경기도 구리시", "경기도 군포시", "경기도 김포시", "경기도 남양주시", "경기도 동두천시", "경기도 부천시", "경기도 성남시 분당구", "경기도 성남시 수정구", "경기도 성남시 중원구", "경기도 수원시 권선구", "경기도 수원시 영통구", "경기도 수원시 장안구", "경기도 수원시 팔달구", "경기도 시흥시", "경기도 안산시 단원구", "경기도 안산시 상록구", "경기도 안성시", "경기도 안양시 동안구", "경기도 안양시 만안구", "경기도 양주시", "경기도 양평군", "경기도 여주시", "경기도 연천군", "경기도 오산시", "경기도 용인시 기흥구", "경기도 용인시 수지구", "경기도 용인시 처인구", "경기도 의왕시", "경기도 의정부시", "경기도 이천시", "경기도 파주시", "경기도 평택시", "경기도 포천시", "경기도 하남시", "경기도 화성시", 
  "강원특별자치도 강릉시", "강원특별자치도 고성군", "강원특별자치도 동해시", "강원특별자치도 삼척시", "강원특별자치도 속초시", "강원특별자치도 양구군", "강원특별자치도 양양군", "강원특별자치도 영월군", "강원특별자치도 원주시", "강원특별자치도 인제군", "강원특별자치도 정선군", "강원특별자치도 철원군", "강원특별자치도 춘천시", "강원특별자치도 태백시", "강원특별자치도 평창군", "강원특별자치도 홍천군", "강원특별자치도 화천군", "강원특별자치도 횡성군", 
  "충청북도 괴산군", "충청북도 단양군", "충청북도 보은군", "충청북도 영동군", "충청북도 옥천군", "충청북도 음성군", "충청북도 제천시", "충청북도 증평군", "충청북도 진천군", "충청북도 청주시 상당구", "충청북도 청주시 서원구", "충청북도 청주시 청원구", "충청북도 청주시 흥덕구", "충청북도 충주시", 
  "충청남도 계룡시", "충청남도 공주시", "충청남도 금산군", "충청남도 논산시", "충청남도 당진시", "충청남도 보령시", "충청남도 부여군", "충청남도 서산시", "충청남도 서천군", "충청남도 아산시", "충청남도 예산군", "충청남도 천안시 동남구", "충청남도 천안시 서북구", "충청남도 청양군", "충청남도 태안군", "충청남도 홍성군", 
  "전북특별자치도 고창군", "전북특별자치도 군산시", "전북특별자치도 김제시", "전북특별자치도 남원시", "전북특별자치도 무주군", "전북특별자치도 부안군", "전북특별자치도 순창군", "전북특별자치도 완주군", "전북특별자치도 익산시", "전북특별자치도 임실군", "전북특별자치도 장수군", "전북특별자치도 전주시 덕진구", "전북특별자치도 전주시 완산구", "전북특별자치도 정읍시", "전북특별자치도 진안군", 
  "전라남도 강진군", "전라남도 고흥군", "전라남도 곡성군", "전라남도 광양시", "전라남도 구례군", "전라남도 나주시", "전라남도 담양군", "전라남도 목포시", "전라남도 무안군", "전라남도 보성군", "전라남도 순천시", "전라남도 신안군", "전라남도 여수시", "전라남도 영광군", "전라남도 영암군", "전라남도 완도군", "전라남도 장성군", "전라남도 장흥군", "전라남도 진도군", "전라남도 함평군", "전라남도 해남군", "전라남도 화순군", 
  "경상북도 경산시", "경상북도 경주시", "경상북도 고령군", "경상북도 구미시", "경상북도 김천시", "경상북도 문경시", "경상북도 봉화군", "경상북도 상주시", "경상북도 성주군", "경상북도 안동시", "경상북도 영덕군", "경상북도 영양군", "경상북도 영주시", "경상북도 영천시", "경상북도 예천군", "경상북도 울릉군", "경상북도 울진군", "경상북도 의성군", "경상북도 청도군", "경상북도 청송군", "경상북도 칠곡군", "경상북도 포항시 남구", "경상북도 포항시 북구", 
  "경상남도 거제시", "경상남도 거창군", "경상남도 고성군", "경상남도 김해시", "경상남도 남해군", "경상남도 밀양시", "경상남도 사천시", "경상남도 산청군", "경상남도 양산시", "경상남도 의령군", "경상남도 진주시", "경상남도 창녕군", "경상남도 창원시 마산합포구", "경상남도 창원시 마산회원구", "경상남도 창원시 성산구", "경상남도 창원시 의창구", "경상남도 창원시 진해구", "경상남도 통영시", "경상남도 하동군", "경상남도 함안군", "경상남도 함양군", "경상남도 합천군", 
  "제주특별자치도 서귀포시", "제주특별자치도 제주시"
];

// ---------------------------------------------------------
// 지원 언어 목록
// ---------------------------------------------------------
final List<Map<String, String>> supportedLanguages = [
  {'code': 'ko', 'flag': '🇰🇷', 'name': '한국어'},
  {'code': 'en', 'flag': '🇺🇸', 'name': 'English'},
  {'code': 'vi', 'flag': '🇻🇳', 'name': 'Tiếng Việt'},
  {'code': 'zh', 'flag': '🇨🇳', 'name': '中文'},
  {'code': 'th', 'flag': '🇹🇭', 'name': 'ไทย'},
  {'code': 'uz', 'flag': '🇺🇿', 'name': 'Oʻzbekcha'},
  {'code': 'ru', 'flag': '🇷🇺', 'name': 'Русский'},
  {'code': 'fil', 'flag': '🇵🇭', 'name': 'Filipino'},
  {'code': 'km', 'flag': '🇰🇭', 'name': 'ភាសាខ្មែរ'},
  {'code': 'ne', 'flag': '🇳🇵', 'name': 'नेपाली'},
  {'code': 'id', 'flag': '🇮🇩', 'name': 'Bahasa Indonesia'},
  {'code': 'mn', 'flag': '🇲🇳', 'name': 'Монгол'},
  {'code': 'my', 'flag': '🇲🇲', 'name': 'Myanmar'},
  {'code': 'ur', 'flag': '🇵🇰', 'name': 'اردو'},
  {'code': 'bn', 'flag': '🇧🇩', 'name': 'বাংলা'},
  {'code': 'si', 'flag': '🇱🇰', 'name': 'Sriranka'},
  {'code': 'lo', 'flag': '🇱🇦', 'name': 'ລາວ'},
  {'code': 'tet', 'flag': '🇹🇱', 'name': 'Tetun'},
  {'code': 'hi', 'flag': '🇮🇳', 'name': 'हिन्दी'},
  {'code': 'fr', 'flag': '🇫🇷', 'name': 'Français'},
  {'code': 'ja', 'flag': '🇯🇵', 'name': '日本語'},
];

// ---------------------------------------------------------
// 다국어 번역 데이터
// ---------------------------------------------------------
final Map<String, Map<String, String>> localizedValues = {
  'ko': {
    'search_hint': '찾고 싶은 상품을 검색해보세요!',
    'sell': '판매하기',
    'login': '로그인',
    'logout': '로그아웃',
    'mypage': '마이페이지',
    'cart': '장바구니',
    'category': '카테고리',
    'admin_page': '관리자',
    'best_seller': '베스트 셀러',
    'special_price': '특가진행중',
    'health': '헬스 / 건강식품',
    'beauty': '뷰티 / 화장품',
    'food': '식품 / K-Food',
    'daily': '생활용품',
    'electronics': '가전 / IT 기기',
    'fashion': '패션 / 의류',
    'safety': '작업 / 안전용품',
    'cart_title': '장바구니',
    'cart_empty': '장바구니에 담긴 상품이 없습니다.',
    'order_summary': '주문 예상 금액',
    'total_prod_price': '총 상품 가격',
    'total_discount': '총 할인',
    'shipping_fee': '총 배송비',
    'final_payment': '총 결제금액',
    'checkout': '구매하기',
    'delete': '삭제',
    'search_result': '검색 결과',
    'no_search_result': '검색 결과가 없습니다.',
    'prod_snack': '다파니 달콤 바삭 미니 한입 꽈배기 대용량 100개입',
    'prod_ginseng': '고려 6년근 홍삼정 스틱 100포 선물세트',
    'prod_coffee': '맥심 모카골드 마일드 커피믹스 180개입 + 20개',
    'detail_tab_info': '상품 상세',
    'detail_tab_review': '상품 리뷰',
    'detail_tab_qna': '상품/배송/교환/반품/문의', // [수정됨] 요청하신 텍스트 반영
    'qna_notice_1': '가격, 판매자, 교환/환불 및 배송 등 해당 상품 자체와 관련 없는 문의는 외국인정보센터 내 온라인 상담을 이용해주세요.',
    'qna_notice_2': '"해당 상품 자체"와 관계없는 글, 양도, 광고성, 욕설, 비방, 도배 등의 글은 예고 없이 이동, 노출제한, 삭제 등의 조치가 취해질 수 있습니다.',
    'qna_notice_3': '공개 게시판이므로 전화번호, 메일 주소 등 고객님의 소중한 개인정보는 절대 남기지 말아주세요.',
    'write_inquiry': '문의하기',
    'login_needed_qna': '로그인 사용자만 이용 가능',
  },
  'en': {
    'search_hint': 'Search for products...',
    'sell': 'Sell',
    'login': 'Login',
    'logout': 'Logout',
    'mypage': 'My Page',
    'cart': 'Cart',
    'category': 'Category',
    'admin_page': 'Admin',
    'best_seller': 'Best Sellers',
    'special_price': 'Special Offer',
    'health': 'Health / Supplements',
    'beauty': 'Beauty / Cosmetics',
    'food': 'Food / K-Food',
    'daily': 'Daily Essentials',
    'electronics': 'Electronics / IT',
    'fashion': 'Fashion / Clothing',
    'safety': 'Work / Safety Gear',
    'cart_title': 'Shopping Cart',
    'cart_empty': 'Your cart is empty.',
    'order_summary': 'Order Summary',
    'total_prod_price': 'Total Item Price',
    'total_discount': 'Total Discount',
    'shipping_fee': 'Shipping Fee',
    'final_payment': 'Final Payment',
    'checkout': 'Checkout',
    'delete': 'Delete',
    'search_result': 'Search Results',
    'no_search_result': 'No results found.',
    'prod_snack': 'Dapani Sweet Mini Twisted Korean Donuts 100pcs',
    'prod_ginseng': 'Korean Red Ginseng Extract Stick 100 Pouches Gift Set',
    'prod_coffee': 'Maxim Mocha Gold Mild Coffee Mix 180 + 20 sticks',
    'detail_tab_info': 'Product Detail',
    'detail_tab_review': 'Reviews',
    'detail_tab_qna': 'Q&A / Return',
    'qna_notice_1': 'For inquiries unrelated to the product itself (e.g., price, seller, exchange/refund, shipping), please use the online consultation center.',
    'qna_notice_2': 'Posts unrelated to the product, advertisements, profanity, or spam may be deleted without notice.',
    'qna_notice_3': 'This is a public board. Do not leave personal information such as phone numbers or email addresses.',
    'write_inquiry': 'Write Inquiry',
    'login_needed_qna': 'Login Required',
  },
  'vi': {
    'search_hint': 'Tìm kiếm sản phẩm...',
    'sell': 'Bán hàng',
    'login': 'Đăng nhập',
    'logout': 'Đăng xuất',
    'mypage': 'Trang của tôi',
    'cart': 'Giỏ hàng',
    'category': 'Danh mục',
    'admin_page': 'Quản trị',
    'best_seller': 'Sản phẩm bán chạy',
    'special_price': 'Giá đặc biệt',
    'health': 'Sức khỏe / Thực phẩm chức năng',
    'beauty': 'Làm đẹp / Mỹ phẩm',
    'food': 'Thực phẩm / K-Food',
    'daily': 'Đồ dùng hàng ngày',
    'electronics': 'Điện tử / Thiết bị IT',
    'fashion': 'Thời trang / Quần áo',
    'safety': 'Đồ bảo hộ lao động',
    'cart_title': 'Giỏ hàng',
    'cart_empty': 'Giỏ hàng trống.',
    'order_summary': 'Tóm tắt đơn hàng',
    'total_prod_price': 'Tổng tiền hàng',
    'total_discount': 'Tổng giảm giá',
    'shipping_fee': 'Phí vận chuyển',
    'final_payment': 'Tổng thanh toán',
    'checkout': 'Thanh toán',
    'delete': 'Xóa',
    'search_result': 'Kết quả tìm kiếm',
    'no_search_result': 'Không tìm thấy kết quả nào.',
    'prod_snack': 'Bánh quẩy xoắn mini Hàn Quốc 100 cái',
    'prod_ginseng': 'Tinh chất hồng sâm Hàn Quốc 6 năm tuổi',
    'prod_coffee': 'Cà phê hòa tan Maxim Mocha Gold',
    'detail_tab_info': 'Chi tiết sản phẩm',
    'detail_tab_review': 'Đánh giá',
    'detail_tab_qna': 'Hỏi đáp / Đổi trả',
    'qna_notice_1': 'Đối với các thắc mắc không liên quan đến sản phẩm (giá, người bán, đổi/trả, vận chuyển), vui lòng sử dụng trung tâm tư vấn trực tuyến.',
    'qna_notice_2': 'Các bài viết không liên quan, quảng cáo, chửi thề hoặc spam có thể bị xóa mà không cần báo trước.',
    'qna_notice_3': 'Đây là bảng công khai. Vui lòng không để lại thông tin cá nhân.',
    'write_inquiry': 'Viết câu hỏi',
    'login_needed_qna': 'Cần đăng nhập',
  },
  'zh': {}, 'th': {}, 'uz': {}, 'ru': {}, 'fil': {}, 'km': {}, 'ne': {},
  'id': {}, 'mn': {}, 'my': {}, 'ur': {}, 'bn': {}, 'si': {}, 'lo': {},
  'tet': {}, 'hi': {}, 'fr': {}, 'ja': {},
};

// ---------------------------------------------------------
// 더미 데이터 (category, description 포함)
// ---------------------------------------------------------
final List<Product> dummyProducts = [
  Product(
    id: '1', 
    titleKey: "prod_snack", 
    category: "food",
    description: "맛있는 한국 전통 간식입니다. <br> 달콤하고 바삭해요.",
    imageUrl: "https://picsum.photos/500/500?random=1", 
    detailImages: [
      "https://picsum.photos/500/500?random=11",
      "https://picsum.photos/500/500?random=12",
      "https://picsum.photos/500/500?random=13",
    ],
    originalPrice: 18600, 
    discountRate: 45, 
    rating: 4.5, 
    reviewCount: 1828,
    reviews: [
      Review(userName: "김*수", date: "2024.01.15", rating: 5, content: "진짜 맛있어요! 배송도 빠르고 좋습니다.", reviewImage: "https://picsum.photos/100/100?random=101"),
      Review(userName: "Lee**", date: "2024.01.14", rating: 4, content: "양은 많은데 조금 달아요."),
      Review(userName: "Dan", date: "2024.01.10", rating: 5, content: "재구매 의사 있습니다."),
    ],
    qnas: [
      QnA(userName: "박*영", date: "2024.01.15", question: "유통기한이 언제까지인가요?", answer: "안녕하세요 고객님. 현재 출고되는 상품은 2025년 10월까지입니다.", answerDate: "2024.01.15"),
      QnA(userName: "최*철", date: "2024.01.12", question: "대량 구매 가능한가요?", answer: "네 가능합니다. 판매자 센터로 연락주세요.", answerDate: "2024.01.12"),
      QnA(userName: "Guest", date: "2024.01.10", question: "배송 언제 오나요?"),
    ],
  ),
  Product(
    id: '2', 
    titleKey: "prod_ginseng", 
    category: "health",
    description: "면역력 증진에 좋은 홍삼입니다.",
    imageUrl: "https://picsum.photos/500/500?random=2", 
    originalPrice: 120000, 
    discountRate: 60, 
    rating: 5.0, 
    reviewCount: 3402,
    reviews: [],
    qnas: [],
  ),
  Product(
    id: '3', 
    titleKey: "prod_coffee", 
    category: "food",
    description: "국민 커피 맥심 모카골드.",
    imageUrl: "https://picsum.photos/500/500?random=3", 
    originalPrice: 32000, 
    discountRate: 10, 
    rating: 4.8, 
    reviewCount: 15420,
    reviews: [],
    qnas: [],
  ),
];

// 전역 장바구니 리스트
List<CartItem> globalCartItems = [
  CartItem(product: dummyProducts[0]),
  CartItem(product: dummyProducts[1]),
];