import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _mobilePlayer = AudioPlayer();

  static String _fixUrl(String url) {
    if (url.startsWith('//')) {
      return 'https:$url';
    }
    return url;
  }

  static Future<void> play(String url) async {
    final fixedUrl = _fixUrl(url);

    if (kIsWeb) {
      // Tạm thời bỏ qua web, chỉ log warning
      debugPrint('Web audio not supported in this build');
      return;
    } else {
      // ===== MOBILE =====
      try {
        await _mobilePlayer.stop();
        await _mobilePlayer.play(UrlSource(fixedUrl));
      } catch (e) {
        debugPrint('Mobile audio error: $e');
      }
    }
  }

  static Future<void> stop() async {
    if (kIsWeb) {
      debugPrint('Web audio not supported');
    } else {
      await _mobilePlayer.stop();
    }
  }

  static void dispose() {
    if (!kIsWeb) {
      _mobilePlayer.dispose();
    }
  }
}