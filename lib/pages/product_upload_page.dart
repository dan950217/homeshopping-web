// lib/pages/product_upload_page.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/data.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';
import '../repositories/mock_product_repository.dart';

// [신규 클래스] 상세 설명의 각 블록 (글 또는 사진)을 정의
class DescriptionBlock {
  String type; // 'text' 또는 'image'
  TextEditingController? textController; // 텍스트일 경우 사용
  XFile? imageFile; // 이미지일 경우 사용

  DescriptionBlock({
    required this.type,
    this.textController,
    this.imageFile,
  });
}

class ProductUploadPage extends StatefulWidget {
  const ProductUploadPage({super.key});

  @override
  State<ProductUploadPage> createState() => _ProductUploadPageState();
}

class _ProductUploadPageState extends State<ProductUploadPage> {
  // ------------------------------------------------------------------------
  // 상태 변수 및 컨트롤러 정의
  // ------------------------------------------------------------------------
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController(text: "0");
  
  // 상세 설명 블록 리스트 (Google Doc 처럼 위아래로 쌓임)
  List<DescriptionBlock> _descriptionBlocks = [];

  // 메인 상품 이미지 리스트
  List<XFile> _uploadedImages = [];

  String _selectedCategory = categoryKeys[0];
  int _finalPrice = 0;

  final ProductRepository _repository = MockProductRepository();
  final ImagePicker _picker = ImagePicker();

  // ------------------------------------------------------------------------
  // 초기화 및 해제
  // ------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _priceController.addListener(_calculateFinalPrice);
    _discountController.addListener(_calculateFinalPrice);
    
    // 처음에 텍스트 입력 블록 하나 추가
    _addTextBlock();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    _nameController.dispose();
    // 생성된 모든 텍스트 블록의 컨트롤러 해제
    for (var block in _descriptionBlocks) {
      block.textController?.dispose();
    }
    super.dispose();
  }

  // ------------------------------------------------------------------------
  // 로직 함수들
  // ------------------------------------------------------------------------

  // 가격 자동 계산
  void _calculateFinalPrice() {
    int original = int.tryParse(_priceController.text) ?? 0;
    int discount = int.tryParse(_discountController.text) ?? 0;
    
    setState(() {
      if (discount == 0) {
        _finalPrice = original;
      } else {
        _finalPrice = (original * (100 - discount) / 100).round();
      }
    });
  }

  // [메인 이미지] 내 컴퓨터에서 가져오기 (9장 제한)
  Future<void> _pickImage() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      // 9장 초과 체크
      if (_uploadedImages.length + images.length > 9) {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: const Text("알림"),
            content: const Text("상품 이미지는 최대 9장까지 등록 가능합니다."),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("확인"))],
          )
        );
        return;
      }
      setState(() {
        _uploadedImages.addAll(images);
      });
    }
  }

  // [메인 이미지] 순서 변경 (왼쪽으로)
  void _moveImageLeft(int index) {
    if (index > 0) {
      setState(() {
        final item = _uploadedImages.removeAt(index);
        _uploadedImages.insert(index - 1, item);
      });
    }
  }

  // [메인 이미지] 순서 변경 (오른쪽으로)
  void _moveImageRight(int index) {
    if (index < _uploadedImages.length - 1) {
      setState(() {
        final item = _uploadedImages.removeAt(index);
        _uploadedImages.insert(index + 1, item);
      });
    }
  }

  // [상세 설명] 텍스트 블록 추가
  void _addTextBlock() {
    setState(() {
      _descriptionBlocks.add(DescriptionBlock(
        type: 'text',
        textController: TextEditingController(),
      ));
    });
  }

  // [상세 설명] 이미지 블록 추가 (Google Doc 스타일)
  Future<void> _addDescriptionImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        // 이미지 블록 추가
        _descriptionBlocks.add(DescriptionBlock(
          type: 'image',
          imageFile: image,
        ));
        // 이미지 밑에 글을 쓸 수 있게 텍스트 블록도 자동 추가
        _addTextBlock();
      });
    }
  }

  // [상세 설명] 텍스트 스타일 적용 (태그 감싸기)
  void _applyStyleToLastTextBlock(String startTag, String endTag) {
    if (_descriptionBlocks.isEmpty) return;
    
    // 가장 마지막 텍스트 블록을 찾음 (혹은 현재 포커스된 블록을 찾아야 하지만, 편의상 마지막 블록)
    var lastBlock = _descriptionBlocks.lastWhere((b) => b.type == 'text', orElse: () => _descriptionBlocks.first);
    
    if (lastBlock.textController == null) return;

    final controller = lastBlock.textController!;
    final text = controller.text;
    final selection = controller.selection;

    // 선택된 텍스트가 없으면 맨 뒤에 태그 추가
    if (selection.start == -1 || selection.end == -1) {
      final newText = text + "$startTag$endTag";
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length - endTag.length),
      );
      return;
    }

    // 선택된 텍스트를 태그로 감싸기
    final newText = text.replaceRange(
      selection.start, 
      selection.end, 
      "$startTag${text.substring(selection.start, selection.end)}$endTag"
    );

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.end + startTag.length + endTag.length),
    );
  }

  // 상품 등록 완료 처리
  void _submitProduct() async {
    // 1. 숫자 유효성 검사
    if (int.tryParse(_priceController.text) == null || int.tryParse(_discountController.text) == null) {
       showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            content: const Text("가격과 할인율은 숫자만 입력해주세요."),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("확인"))],
          )
        );
        return;
    }

    // 2. 필수값 검사
    if (!_formKey.currentState!.validate()) return;
    
    // 3. 사진 유무 검사
    if (_uploadedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("최소 1장의 대표 사진을 등록해주세요.")));
      return;
    }

    // 4. 상세 설명 조합 (텍스트 블록과 이미지 블록을 하나의 문자열로 합침)
    // 이미지는 [image:경로] 형태로 저장하여 나중에 파싱
    StringBuffer descriptionBuffer = StringBuffer();
    for (var block in _descriptionBlocks) {
      if (block.type == 'text') {
        descriptionBuffer.write("${block.textController?.text}\n");
      } else if (block.type == 'image' && block.imageFile != null) {
        descriptionBuffer.write("[image:${block.imageFile!.path}]\n");
      }
    }

    // 5. 상품 객체 생성
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titleKey: _nameController.text, 
      category: _selectedCategory,
      description: descriptionBuffer.toString(),
      imageUrl: _uploadedImages.first.path, // 0번이 대표 이미지
      detailImages: _uploadedImages.sublist(1).map((e) => e.path).toList(), // 1~8번이 추가 이미지
      originalPrice: int.parse(_priceController.text),
      discountRate: int.parse(_discountController.text),
      rating: 0.0,
      reviewCount: 0,
    );

    // 6. 저장소에 추가
    await _repository.addProduct(newProduct);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("상품이 성공적으로 등록되었습니다!")));
    Navigator.pop(context); // 닫기
  }

  // ------------------------------------------------------------------------
  // 화면 구성 (Build)
  // ------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("상품 등록"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 섹션 1: 대표 이미지 등록 ---
                  const Text("상품 이미지 (최대 9장)", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("드래그는 지원하지 않으며, 화살표로 순서를 변경할 수 있습니다.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 10),
                  
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      // 추가 버튼
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey[50],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt, color: Colors.grey),
                              Text("추가", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      // 등록된 이미지 리스트
                      ..._uploadedImages.asMap().entries.map((entry) {
                        int index = entry.key;
                        XFile file = entry.value;
                        return Stack(
                          children: [
                            Container(
                              width: 100, height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                  image: kIsWeb ? NetworkImage(file.path) : FileImage(File(file.path)) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // 대표/번호 배지
                            Positioned(
                              left: 0, top: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                color: index == 0 ? kCoupangRed : Colors.black54,
                                child: Text(
                                  index == 0 ? "대표" : "${index}", 
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                                ),
                              ),
                            ),
                            // 삭제 버튼
                            Positioned(
                              right: 0, top: 0,
                              child: GestureDetector(
                                onTap: () => setState(() => _uploadedImages.removeAt(index)),
                                child: Container(
                                  color: Colors.black54,
                                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                            // 순서 이동 버튼
                            Positioned(
                              bottom: 0, left: 0, right: 0,
                              child: Container(
                                color: Colors.black45,
                                height: 24,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    if (index > 0)
                                      GestureDetector(
                                        onTap: () => _moveImageLeft(index),
                                        child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                                      ),
                                    if (index < _uploadedImages.length - 1)
                                      GestureDetector(
                                        onTap: () => _moveImageRight(index),
                                        child: const Icon(Icons.chevron_right, color: Colors.white, size: 20),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // --- 섹션 2: 상품 기본 정보 ---
                  _buildTextField("상품명", _nameController, "상품 이름을 입력하세요"),
                  const SizedBox(height: 20),

                  const Text("카테고리", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: categoryKeys.map((key) {
                      String label = localizedValues['ko']?[key] ?? key; 
                      return DropdownMenuItem(value: key, child: Text(label));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val!),
                  ),
                  const SizedBox(height: 20),
                  
                  Row(
                    children: [
                      Expanded(child: _buildTextField("정상가 (원)", _priceController, "예: 10000", isNumber: true)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildTextField("할인율 (%)", _discountController, "0", isNumber: true, isRequired: false)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 최종 판매가 미리보기
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("최종 판매가", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("${NumberFormat('###,###').format(_finalPrice)}원", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kCoupangRed)),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // --- 섹션 3: 상품 상세 설명 (Google Doc 스타일) ---
                  const Text("상품 상세 설명", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text("텍스트와 이미지를 자유롭게 추가하여 상세페이지를 꾸며보세요.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 10),
                  
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        // 에디터 툴바
                        Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Wrap(
                            spacing: 5,
                            children: [
                              _EditorToolbarButton(icon: Icons.format_bold, onTap: () => _applyStyleToLastTextBlock('<b>', '</b>')),
                              _EditorToolbarButton(icon: Icons.format_italic, onTap: () => _applyStyleToLastTextBlock('<i>', '</i>')),
                              _EditorToolbarButton(icon: Icons.format_underline, onTap: () => _applyStyleToLastTextBlock('<u>', '</u>')),
                              _EditorToolbarButton(icon: Icons.text_increase, onTap: () => _applyStyleToLastTextBlock('<big>', '</big>')),
                              const SizedBox(width: 10),
                              // 색상 버튼들
                              _EditorToolbarButton(icon: Icons.circle, color: Colors.red, onTap: () => _applyStyleToLastTextBlock('<color:red>', '</color>')),
                              _EditorToolbarButton(icon: Icons.circle, color: Colors.blue, onTap: () => _applyStyleToLastTextBlock('<color:blue>', '</color>')),
                              _EditorToolbarButton(icon: Icons.circle, color: Colors.green, onTap: () => _applyStyleToLastTextBlock('<color:green>', '</color>')),
                              _EditorToolbarButton(icon: Icons.circle, color: Colors.orange, onTap: () => _applyStyleToLastTextBlock('<color:orange>', '</color>')),
                              _EditorToolbarButton(icon: Icons.circle, color: Colors.purple, onTap: () => _applyStyleToLastTextBlock('<color:purple>', '</color>')),
                              _EditorToolbarButton(icon: Icons.circle, color: Colors.black, onTap: () => _applyStyleToLastTextBlock('<color:black>', '</color>')),
                              const Spacer(),
                              // 본문 이미지 추가 버튼
                              TextButton.icon(
                                onPressed: _addDescriptionImage,
                                icon: const Icon(Icons.add_photo_alternate, size: 20),
                                label: const Text("본문 사진 추가"),
                              ),
                            ],
                          ),
                        ),
                        
                        // 편집 영역 (블록 리스트)
                        Container(
                          height: 500, // 고정 높이
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: _descriptionBlocks.length,
                            itemBuilder: (context, index) {
                              final block = _descriptionBlocks[index];
                              
                              // 1. 텍스트 블록인 경우
                              if (block.type == 'text') {
                                return TextField(
                                  controller: block.textController,
                                  maxLines: null, // 자동 줄바꿈
                                  decoration: const InputDecoration(
                                    hintText: "내용을 입력하세요...",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                                  ),
                                );
                              } 
                              // 2. 이미지 블록인 경우
                              else {
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      width: double.infinity,
                                      height: 250,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade200),
                                      ),
                                      child: kIsWeb 
                                        ? Image.network(block.imageFile!.path, fit: BoxFit.contain)
                                        : Image.file(File(block.imageFile!.path), fit: BoxFit.contain),
                                    ),
                                    // 이미지 삭제 버튼
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _descriptionBlocks.removeAt(index);
                                        });
                                      },
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 등록 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _submitProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Text("상품 등록하기", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {bool isNumber = false, bool isRequired = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return "필수 입력 항목입니다.";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
        ),
      ],
    );
  }
}

class _EditorToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _EditorToolbarButton({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right: 5),
        child: Icon(icon, size: 20, color: color ?? Colors.grey[800]),
      ),
    );
  }
}