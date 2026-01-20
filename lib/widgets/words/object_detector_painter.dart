import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ObjectDetectorPainter extends CustomPainter {
  final List<DetectedObject> objects;
  final Size previewSize; // Kích thước preview từ camera
  final Map<String, dynamic> dictionary;

  ObjectDetectorPainter(this.objects, this.previewSize, this.dictionary);

  @override
  void paint(Canvas canvas, Size size) {
    // Lưu ý: previewSize.height/width có thể bị đảo ngược tùy theo thiết bị
    // Ta tính toán tỷ lệ khớp với màn hình thực tế (size)
    final double scaleX = size.width / previewSize.height;
    final double scaleY = size.height / previewSize.width;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.cyanAccent;

    for (final object in objects) {
      // Chuyển đổi tọa độ khung
      final rect = Rect.fromLTRB(
        object.boundingBox.left * scaleX,
        object.boundingBox.top * scaleY,
        object.boundingBox.right * scaleX,
        object.boundingBox.bottom * scaleY,
      );

      // Vẽ khung
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        paint,
      );

      // Vẽ text
      if (object.labels.isNotEmpty) {
        final label = object.labels.first;
        final dynamic wordData = dictionary[label.text];

        String mainText = label.text; // Tiếng Anh
        String subText = "";

        if (wordData != null && wordData is Map) {
          mainText = "${wordData['en'] ?? label.text}: ${wordData['vn'] ?? ''}";
          subText = wordData['ipa'] ?? "";
        }

        _drawText(canvas, rect, mainText, subText);
      }
    }
  }

  void _drawText(Canvas canvas, Rect rect, String main, String sub) {
    final span = TextSpan(
      children: [
        TextSpan(
          text: "$main\n",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: sub,
          style: const TextStyle(color: Colors.yellowAccent, fontSize: 14),
        ),
      ],
    );

    final tp = TextPainter(text: span, textDirection: TextDirection.ltr)
      ..layout();

    // Vẽ nền đen mờ phía sau chữ để dễ đọc hơn
    canvas.drawRect(
      Rect.fromLTWH(
        rect.left,
        rect.top - tp.height - 10,
        tp.width + 10,
        tp.height + 5,
      ),
      Paint()..color = Colors.black54,
    );

    tp.paint(canvas, Offset(rect.left + 5, rect.top - tp.height - 5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
