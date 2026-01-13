import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ObjectDetectorPainter extends CustomPainter {
  final List<DetectedObject> objects;
  final Size imageSize;
  final Map<String, dynamic> dictionary;

  ObjectDetectorPainter(this.objects, this.imageSize, this.dictionary);

  @override
  void paint(Canvas canvas, Size size) {
    // Tính toán tỷ lệ khung hình giữa ảnh camera và màn hình thực tế
    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.cyanAccent;

    for (final object in objects) {
      // Chuyển đổi tọa độ khung bao quanh vật thể
      final rect = Rect.fromLTRB(
        object.boundingBox.left * scaleX,
        object.boundingBox.top * scaleY,
        object.boundingBox.right * scaleX,
        object.boundingBox.bottom * scaleY,
      );

      // 1. Vẽ khung vuông quanh vật thể
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), paint);

      // 2. Tra từ điển và vẽ chữ
      if (object.labels.isNotEmpty) {
        final label = object.labels.first;
        
        // ML Kit trả về nhãn (ví dụ: "Toothbrush"), ta lấy nhãn đó tra vào Map dictionary
        final dynamic wordData = dictionary[label.text];
        
        String displayText = label.text; // Mặc định hiện tiếng Anh nếu không tìm thấy
        String subText = "";

        // Kiểm tra chắc chắn wordData là một Map trước khi truy xuất ['vn']
        if (wordData != null && wordData is Map) {
          displayText = wordData['vn'] ?? label.text; // Hiện nghĩa VN
          subText = wordData['ipa'] ?? "";            // Hiện phiên âm
        }

        _drawText(canvas, rect, displayText, subText);
      }
    }
  }

  void _drawText(Canvas canvas, Rect rect, String main, String sub) {
    final span = TextSpan(
      children: [
        TextSpan(text: "$main\n", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        TextSpan(text: sub, style: const TextStyle(color: Colors.yellowAccent, fontSize: 14)),
      ],
    );

    final tp = TextPainter(text: span, textDirection: TextDirection.ltr)..layout();
    
    // Vẽ nền đen mờ phía sau chữ để dễ đọc hơn
    canvas.drawRect(
      Rect.fromLTWH(rect.left, rect.top - tp.height - 10, tp.width + 10, tp.height + 5),
      Paint()..color = Colors.black54,
    );
    
    tp.paint(canvas, Offset(rect.left + 5, rect.top - tp.height - 5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}